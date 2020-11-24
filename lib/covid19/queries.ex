defmodule Covid19.Queries do
  @moduledoc false

  alias Covid19.Cache
  alias Covid19.Helpers.PathHelpers
  alias Covid19.Repo
  alias Covid19.Schemas.DailyData
  alias Covid19.Schemas.DailyDataUS

  import Ecto.Query

  use Nebulex.Caching

  @ttl Nebulex.Time.expiry_time(1, :hour)

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
  @type datasets :: :world | :us
  @type dataset_dates :: %{
    us: maybe_dates(),
    world: maybe_dates()
  }
  @type maybe_dates :: [Date.t()] | []
  @type world_summary_type :: %{
    required(:date) => Date.t(),
    required(:deaths) => non_neg_integer(),
    required(:confirmed) => non_neg_integer(),
    required(:recovered) => non_neg_integer(),
    required(:active) => non_neg_integer()
  }

  defdelegate dates(dataset), to: PathHelpers

  @doc """
  Returns the dates for which data was processed
  """
  @spec processed_dates(datasets) :: maybe_dates()
  def processed_dates(:world), do: get_unique_dates(DailyData) |> Enum.sort(Date)
  def processed_dates(:us), do: get_unique_dates(DailyDataUS) |> Enum.sort(Date)

  @spec processed_dates() :: dataset_dates()
  def processed_dates do
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
  def unprocessed_dates do
    %{
      world: unprocessed_dates(:world),
      us: unprocessed_dates(:us)
    }
  end

  @spec world_summary() :: [world_summary_type()]
  def world_summary do
    summary = [nil | group_by_dates()]

    summary
    |> Enum.zip(tl(summary))
    |> Enum.map(&calculate_diffs/1)
  end

  @spec summary_by_country(Date.t()) :: [country_type()]
  def summary_by_country(%Date{} = date) do
    yesterday = single_summary_by_country(Date.add(date, -1))
    empty_country = %{
      deaths: 0,
      confirmed: 0,
      recovered: 0
    }

    date
    |> single_summary_by_country()
    |> Enum.map(fn {country, data} ->
      by_country = Map.get(yesterday, country, empty_country)

      data
      |> Map.update(:new_deaths, 0, fn _ -> data.deaths - by_country.deaths end)
      |> Map.update(:new_confirmed, 0, fn _ ->
        data.confirmed - by_country.confirmed
      end)
      |> Map.update(:new_recovered, 0, fn _ ->
        data.recovered - by_country.recovered
      end)
    end)
  end

  def locations_for_date(date) do
    locations = country_locations()

    group_by_locations(date)
    |> Enum.map(fn row ->
      case row do
        %{latitude: nil, longitude: nil, country_or_region: name} ->
          %{row | latitude: locations[name][:latitude], longitude: locations[name][:longitude]}

        _ ->
          row
      end
    end)
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

  defp calculate_diffs({nil, today}), do: today
  defp calculate_diffs({yesterday, today}) do
    Map.merge(today, %{
      new_confirmed: today.confirmed - yesterday.confirmed,
      new_deaths: today.deaths - yesterday.deaths,
      new_recovered: today.recovered - yesterday.recovered,
      new_active: today.active - yesterday.active
    })
  end

  defp single_summary_by_country(%Date{} = date) do
    locations = country_locations()

    group_by_countries(date)
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

  @decorate cacheable(cache: Cache, key: :gbd, opts: [ttl: @ttl])
  defp group_by_dates() do
    DailyData
    |> group_by([e], e.date)
    |> select([e], %{
      date: e.date,
      deaths: coalesce(sum(e.deaths), 0),
      confirmed: coalesce(sum(e.confirmed), 0),
      recovered: coalesce(sum(e.recovered), 0),
      active: coalesce(sum(e.confirmed), 0) - (coalesce(sum(e.recovered), 0) + coalesce(sum(e.deaths), 0))
    })
    |> order_by([e], e.date)
    |> Repo.all()
    |> Enum.map(fn data ->
      data
      |> Map.put_new(:new_confirmed, nil)
      |> Map.put_new(:new_deaths, nil)
      |> Map.put_new(:new_recovered, nil)
      |> Map.put_new(:new_active, nil)
    end)
  end

  @decorate cacheable(cache: Cache, key: {:gbc, date}, opts: [ttl: @ttl])
  defp group_by_countries(date) do
    DailyData
    |> where([e], e.date == ^date)
    |> group_by([e], e.country_or_region)
    |> select([e], %{
      country_or_region: e.country_or_region,
      deaths: coalesce(sum(e.deaths), 0),
      confirmed: coalesce(sum(e.confirmed), 0),
      recovered: coalesce(sum(e.recovered), 0),
      active: coalesce(sum(e.confirmed), 0) - (coalesce(sum(e.recovered), 0) + coalesce(sum(e.deaths), 0))
    })
    |> order_by([e], e.country_or_region)
    |> Repo.all()
  end

  @decorate cacheable(cache: Cache, key: {:gbl, date}, opts: [ttl: @ttl])
  defp group_by_locations(date) do
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
      deaths: coalesce(sum(e.deaths), 0),
      confirmed: coalesce(sum(e.confirmed), 0),
      recovered: coalesce(sum(e.recovered), 0),
      active: coalesce(sum(e.confirmed), 0) - (coalesce(sum(e.recovered), 0) + coalesce(sum(e.deaths), 0))
    })
    |> Repo.all()
  end

  @decorate cacheable(cache: Cache, key: {:ud, schema}, opts: [ttl: @ttl])
  defp get_unique_dates(schema) do
    schema
    |> select([d], d.date)
    |> distinct(true)
    |> Repo.all()
  end
end
