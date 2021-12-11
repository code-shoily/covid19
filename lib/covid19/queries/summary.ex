defmodule Covid19.Queries.Summary do
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
  Get datewise global summary
  """
  @spec global_summary() :: [Types.global_summary_type()]
  def global_summary do
    group_by_dates()
    |> order_by([e], e.date)
    |> Repo.all()
    |> then(fn data -> [nil | data] end)
    |> then(fn summary -> Enum.zip(summary, tl(summary)) end)
    |> Enum.map(&calculate_diffs/1)
  end

  defp latest_query(type) do
    type
    |> get_schema()
    |> distinct(desc: :date)
    |> order_by(desc: :date)
  end

  defp group_by_dates do
    DailyData
    |> group_by([e], e.date)
    |> select([e], %{
      confirmed: coalesce(sum(e.confirmed), nil),
      date: e.date,
      deaths: coalesce(sum(e.deaths), nil),
      number_of_countries: fragment("COUNT(distinct country_or_region)"),
      number_of_states: fragment("COUNT(distinct province_or_state)"),
      src: max(e.src)
    })
  end

  defp calculate_diffs({nil, today}), do: today

  defp calculate_diffs({yesterday, today}) do
    Map.merge(today, %{
      new_confirmed: coerced_difference(today.confirmed, yesterday.confirmed),
      new_deaths: coerced_difference(today.deaths, yesterday.deaths)
    })
  end

  defp coerced_difference(nil, nil), do: 0
  defp coerced_difference(nil, value), do: -value
  defp coerced_difference(value, nil), do: value
  defp coerced_difference(a, b), do: a - b

  defp get_schema(:global), do: DailyData
  defp get_schema(:us), do: DailyDataUS
end
