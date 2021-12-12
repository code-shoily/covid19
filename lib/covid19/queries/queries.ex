defmodule Covid19.Queries do
  @moduledoc """
  All schema related queries.
  """
  alias Covid19.Queries.Types
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
  def summary_by_dates do
    DailyData
    |> select([i], %{
      confirmed: sum(i.confirmed),
      country_or_region: count(fragment("DISTINCT country_or_region")),
      date: i.date,
      deaths: sum(i.deaths),
      last_updated: max(i.timestamp),
      province_or_state: count(fragment("DISTINCT province_or_state"))
    })
    |> group_by([i], i.date)
    |> subquery()
    |> select([i], %{
      confirmed: i.confirmed,
      country_or_region: i.country_or_region,
      date: i.date,
      deaths: i.deaths,
      last_updated: i.last_updated,
      new_confirmed: i.confirmed - over(lag(i.confirmed, 1), :window),
      new_deaths: i.deaths - over(lag(i.deaths, 1), :window),
      province_or_state: i.province_or_state
    })
    |> windows(window: [order_by: :date])
    |> Repo.all()
  end

  @doc """
  Get datewise country summary. This will return country-wise aggregate data per
  date.
  """
  @spec countries_or_regions_for_date(Date.t()) :: Types.country_summary()
  def countries_or_regions_for_date(date) do
    previous_date = Date.add(date, -1)

    DailyData
    |> select([i], %{
      confirmed: sum(i.confirmed),
      country_or_region: i.country_or_region,
      date: i.date,
      deaths: sum(i.deaths),
      province_or_state: count(fragment("DISTINCT province_or_state")),
    })
    |> where([i], i.date >= ^previous_date)
    |> where([i], i.date <= ^date)
    |> group_by([i], [i.date, i.country_or_region])
    |> subquery()
    |> select([i], %{
      confirmed: i.confirmed,
      country_or_region: i.country_or_region,
      date: i.date,
      deaths: i.deaths,
      new_confirmed: i.confirmed - over(lag(i.confirmed, 1), :window),
      new_deaths: i.deaths - over(lag(i.deaths, 1), :window),
      province_or_state: i.province_or_state,
    })
    |> windows(window: [partition_by: :country_or_region, order_by: :date])
    |> subquery()
    |> where([i], i.date == ^date)
    |> Repo.all()
  end

  @doc """
  Get location summary. This will return data per location (Lat/Lng)
  """
  @spec locations_for_date(Date.t()) :: Types.location_summary()
  def locations_for_date(date) do
    previous_date = Date.add(date, -1)

    DailyData
    |> select([i], %{
      case_fatality_ratio: i.case_fatality_ratio,
      confirmed: i.confirmed,
      country_or_region: i.country_or_region,
      deaths: i.deaths,
      incidence_rate: i.incidence_rate,
      latitude: i.latitude,
      longitude: i.longitude,
    })
    |> where([i], i.date >= ^previous_date)
    |> where([i], i.date <= ^date)
    |> Repo.all()
  end

  @doc """
  Get country data summarized by dates. This will return datewise data for a
  country.
  """
  @spec country_or_region_by_dates(Types.country_name()) ::
          Types.country_summary()
  def country_or_region_by_dates(country) do
    DailyData
    |> select([i], %{
      confirmed: sum(i.confirmed),
      country_or_region: i.country_or_region,
      date: i.date,
      deaths: sum(i.deaths),
      province_or_state: count(fragment("DISTINCT province_or_state"))
    })
    |> where([i], i.country_or_region == ^country)
    |> group_by([i], [i.date, i.country_or_region])
    |> subquery()
    |> select([i], %{
      confirmed: i.confirmed,
      country_or_region: i.country_or_region,
      date: i.date,
      deaths: i.deaths,
      new_confirmed: i.confirmed - over(lag(i.confirmed, 1), :window),
      new_deaths: i.deaths - over(lag(i.deaths, 1), :window),
      province_or_state: i.province_or_state
    })
    |> windows(window: [partition_by: :country_or_region, order_by: :date])
    |> Repo.all()
  end

  @doc """
  Get province or state data summarized for date. This will return all province
  or state data for a country for a given date.
  """
  @spec provinces_or_states_for_date(Types.country_name(), Date.t()) ::
          Types.province_or_state_summary()
  def provinces_or_states_for_date(country, date) do
    previous_date = Date.add(date, -1)

    DailyData
    |> select([i], %{
      confirmed: sum(i.confirmed),
      country_or_region: i.country_or_region,
      date: i.date,
      deaths: sum(i.deaths),
      province_or_state: i.province_or_state
    })
    |> where([i], i.country_or_region == ^country)
    |> where([i], i.date >= ^previous_date)
    |> where([i], i.date <= ^date)
    |> group_by([i], [i.date, i.country_or_region, i.province_or_state])
    |> subquery()
    |> select([i], %{
      confirmed: i.confirmed,
      country_or_region: i.country_or_region,
      date: i.date,
      deaths: i.deaths,
      new_confirmed: i.confirmed - over(lag(i.confirmed, 1), :window),
      new_deaths: i.deaths - over(lag(i.deaths, 1), :window),
      province_or_state: i.province_or_state
    })
    |> windows(window: [partition_by: :province_or_state, order_by: :date])
    |> subquery()
    |> where([i], i.date == ^date)
    |> Repo.all()
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
