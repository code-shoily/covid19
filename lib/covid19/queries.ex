defmodule Covid19.Queries do
  @moduledoc false

  alias Covid19.Helpers.PathHelpers
  alias Covid19.Repo
  alias Covid19.Schemas.DailyData
  alias Covid19.Schemas.DailyDataUS

  import Ecto.Query

  @type datasets :: :world | :us
  @type maybe_dates :: [Date.t()] | []
  @type dataset_dates :: %{
          us: maybe_dates(),
          world: maybe_dates()
        }

  defdelegate dates(dataset), to: PathHelpers

  @doc """
  Returns the dates for which data was processed
  """
  @spec processed_dates(datasets) :: maybe_dates()
  def processed_dates(:world), do: get_unique_dates(DailyData) |> Enum.sort(Date)

  def processed_dates(:us), do: get_unique_dates(DailyDataUS) |> Enum.sort(Date)

  @spec processed_dates() :: dataset_dates()
  def processed_dates() do
    %{
      world: processed_dates(:world),
      us: processed_dates(:us)
    }
  end

  @spec unprocessed_dates(datasets()) :: maybe_dates()
  def unprocessed_dates(dataset) do
    file_dates = dates(dataset) |> MapSet.new()
    db_dates = processed_dates(dataset) |> MapSet.new()

    MapSet.difference(file_dates, db_dates) |> MapSet.to_list() |> Enum.sort(Date)
  end

  @spec unprocessed_dates() :: dataset_dates()
  def unprocessed_dates() do
    %{
      world: unprocessed_dates(:world),
      us: unprocessed_dates(:us)
    }
  end

  defp get_unique_dates(schema) do
    schema
    |> select([d], d.date)
    |> distinct(true)
    |> Repo.all()
  end

  @type world_summary_type :: %{
          required(:date) => Date.t(),
          required(:deaths) => non_neg_integer(),
          required(:confirmed) => non_neg_integer(),
          required(:recovered) => non_neg_integer(),
          required(:active) => non_neg_integer()
        }
  @spec world_summary() :: [world_summary_type()]
  def world_summary() do
    data =
      DailyData
      |> group_by([e], e.date)
      |> select([e], %{
        date: e.date,
        deaths: fragment("COALESCE(SUM(deaths), 0)"),
        confirmed: fragment("COALESCE(SUM(confirmed), 0)"),
        recovered: fragment("COALESCE(SUM(recovered), 0)")
      })
      |> order_by([e], e.date)
      |> Repo.all()
      |> Enum.map(&calculate_active/1)
      |> Enum.map(fn data ->
        data
        |> Map.put_new(:new_confirmed, nil)
        |> Map.put_new(:new_deaths, nil)
        |> Map.put_new(:new_recovered, nil)
        |> Map.put_new(:new_active, nil)
      end)

    [nil | data]
    |> Enum.zip(data)
    |> Enum.map(fn
      {nil, a} ->
        a

      {a, b} ->
        b
        |> Map.put(:new_confirmed, b.confirmed - a.confirmed)
        |> Map.put(:new_deaths, b.deaths - a.deaths)
        |> Map.put(:new_recovered, b.recovered - a.recovered)
        |> Map.put(:new_active, b.active - a.active)
    end)
  end

  @empty_country %{
    deaths: 0,
    confirmed: 0,
    recovered: 0
  }
  @type country_type :: %{
          required(:country_or_region) => String.t(),
          required(:deaths) => integer(),
          required(:recovered) => integer(),
          required(:confirmed) => integer(),
          required(:active) => integer(),
          required(:new_deaths) => integer(),
          required(:new_recovered) => integer(),
          required(:new_confirmed) => integer()
        }
  @spec summary_by_country(Date.t()) :: [country_type()]
  def summary_by_country(%Date{} = date) do
    previous_data = single_summary_by_country(Date.add(date, -1))

    date
    |> single_summary_by_country()
    |> Enum.map(fn {country, data} ->
      previous_country_data = Map.get(previous_data, country, @empty_country)

      data
      |> Map.update(:new_deaths, 0, fn _ -> data.deaths - previous_country_data.deaths end)
      |> Map.update(:new_confirmed, 0, fn _ ->
        data.confirmed - previous_country_data.confirmed
      end)
      |> Map.update(:new_recovered, 0, fn _ ->
        data.recovered - previous_country_data.recovered
      end)
    end)
  end

  def locations_for_date(date) do
    locations = country_locations()

    DailyData
    |> where([e], e.date == ^date)
    |> group_by([e], e.date)
    |> group_by([e], e.latitude)
    |> group_by([e], e.longitude)
    |> group_by([e], e.country_or_region)
    |> select([e], %{
      date: e.date,
      country_or_region: e.country_or_region,
      latitude: e.latitude,
      longitude: e.longitude,
      deaths: fragment("COALESCE(SUM(deaths), 0)"),
      confirmed: fragment("COALESCE(SUM(confirmed), 0)"),
      recovered: fragment("COALESCE(SUM(recovered), 0)")
    })
    |> Repo.all()
    |> Enum.map(&calculate_active/1)
    |> Enum.map(fn row ->
      case row do
        %{latitude: nil, longitude: nil, country_or_region: name} ->
          %{row | latitude: locations[name][:latitude], longitude: locations[name][:longitude]}

        _ ->
          row
      end
    end)
  end

  defp calculate_active(
         %{
           confirmed: confirmed,
           recovered: recovered,
           deaths: deaths
         } = data
       ) do
    Map.put(data, :active, confirmed - (recovered + deaths))
  end

  defp single_summary_by_country(%Date{} = date) do
    locations = country_locations()

    DailyData
    |> where([e], e.date == ^date)
    |> group_by([e], e.country_or_region)
    |> select([e], %{
      country_or_region: e.country_or_region,
      deaths: fragment("COALESCE(SUM(deaths), 0)"),
      confirmed: fragment("COALESCE(SUM(confirmed), 0)"),
      recovered: fragment("COALESCE(SUM(recovered), 0)")
    })
    |> order_by([e], e.country_or_region)
    |> Repo.all()
    |> Enum.map(&calculate_active/1)
    |> Enum.map(fn row ->
      row
      |> Map.put_new(:new_deaths, row.deaths)
      |> Map.put_new(:new_confirmed, row.confirmed)
      |> Map.put_new(:new_recovered, row.recovered)
      |> (fn %{country_or_region: name} = data ->
            case locations[name] do
              nil ->
                data

              %{latitude: latitude, longitude: longitude} ->
                data
                |> Map.put_new(:latitude, latitude)
                |> Map.put_new(:longitude, longitude)
            end
          end).()
    end)
    |> Enum.group_by(& &1.country_or_region)
    |> Enum.map(fn {k, v} -> {k, hd(v)} end)
    |> Enum.into(%{})
  end

  defp country_locations do
    Countries.all()
    |> Enum.reject(&is_nil(&1.geo))
    |> Enum.map(fn %{name: name, geo: %{latitude: latitude, longitude: longitude}} ->
      %{name: name, latitude: latitude, longitude: longitude}
    end)
    |> Enum.group_by(& &1.name)
    |> Enum.map(fn {name, geos} -> {name, hd(geos)} end)
    |> Enum.into(%{})
  end
end
