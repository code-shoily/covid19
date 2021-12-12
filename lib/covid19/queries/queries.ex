defmodule Covid19.Queries do
  @moduledoc """
  All schema related queries.
  """
  alias Covid19.Queries.{SQL, Types}
  alias Covid19.Repo
  alias Covid19.Schema.{DailyData, DailyDataUS}

  import Ecto.Query

  @doc """
  Returns a set of dates for which data is present in the database for either
  global or us data.
  """
  @spec dates_loaded(Types.datasets()) :: MapSet.t()
  def dates_loaded(type) do
    type
    |> get_schema()
    |> distinct([:date])
    |> select([r], r.date)
    |> Repo.all()
    |> MapSet.new()
  end

  @doc """
  Returns the latest dates that are in the table.
  """
  @spec latest(non_neg_integer(), Types.datasets()) :: Types.maybe_dates()
  def latest(number_of_days, type) do
    type
    |> latest_query()
    |> limit(^number_of_days)
    |> Repo.all()
  end

  @doc """
  Returns all available dates, in descending order.
  """
  @spec dates(Types.datasets()) :: Types.maybe_dates()
  def dates(type) do
    type
    |> latest_query()
    |> select([i], i.date)
    |> Repo.all()
  end

  @doc """
  Get datewise global summary. This will return global aggregate data per date.
  """
  @spec summary_by_dates() :: Types.world_summary()
  def summary_by_dates, do: execute(SQL.summary_by_dates())

  @doc """
  Get datewise country summary. This will return country-wise aggregate data per
  date.
  """
  @spec countries_or_regions_for_date(Date.t()) :: Types.country_summary()
  def countries_or_regions_for_date(date),
    do: execute(SQL.countries_or_regions_for_date(), [Date.add(date, -1), date])

  @doc """
  Get location summary. This will return data per location (Lat/Lng)
  """
  @spec locations_for_date(Date.t()) :: Types.location_summary()
  def locations_for_date(date), do: execute(SQL.locations_for_date(), [date])

  @doc """
  Get country data summarized by dates. This will return datewise data for a
  country.
  """
  @spec country_or_region_by_dates(Types.country_name()) ::
          Types.country_summary()
  def country_or_region_by_dates(country),
    do: execute(SQL.country_or_region_by_dates(), [country])

  @doc """
  Get province or state data summarized for date. This will return all province
  or state data for a country for a given date.
  """
  @spec provinces_or_states_for_date(Types.country_name(), Date.t()) ::
          Types.province_or_state_summary()
  def provinces_or_states_for_date(country, date),
    do:
      execute(
        SQL.provinces_or_states_for_date(),
        [Date.add(date, -1), date, country]
      )

  @spec execute(String.t(), [Date.t() | String.t()]) :: [map()]
  defp execute(query, params \\ []) do
    Repo
    |> Ecto.Adapters.SQL.query!(query, params)
    |> then(fn %{columns: columns, rows: rows} ->
      columns = Enum.map(columns, &String.to_atom/1)

      Enum.map(rows, fn row ->
        Map.new(Enum.zip(columns, row))
      end)
    end)
  end

  defp latest_query(type) do
    type
    |> get_schema()
    |> distinct(desc: :date)
    |> order_by(desc: :date)
  end

  defp get_schema(:global), do: DailyData
  defp get_schema(:us), do: DailyDataUS
end
