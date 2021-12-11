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

  defp latest_query(type) do
    type
    |> get_schema()
    |> distinct(desc: :date)
    |> order_by(desc: :date)
  end

  defp get_schema(:global), do: DailyData
  defp get_schema(:us), do: DailyDataUS
end
