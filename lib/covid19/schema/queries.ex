defmodule Covid19.Schema.Queries do
  @moduledoc """
  All schema related queries.
  """
  alias Covid19.Repo
  alias Covid19.Schema.{DailyData, DailyDataUS}

  import Ecto.Query

  @type report_type :: :global | :us

  @doc """
  Returns a set of dates for which data is present in the database for either
  global or us data.
  """
  @spec dates_loaded(report_type()) :: MapSet.t()
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
  @spec latest(non_neg_integer(), report_type()) :: [Date.t()]
  def latest(number_of_days, type) do
    type
    |> get_schema()
    |> distinct(desc: :date)
    |> order_by(desc: :date)
    |> limit(^number_of_days)
    |> Repo.all()
  end

  defp get_schema(:global), do: DailyData
  defp get_schema(:us), do: DailyDataUS
end
