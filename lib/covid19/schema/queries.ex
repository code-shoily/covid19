defmodule Covid19.Schema.Queries do
  @moduledoc """
  All schema related queries.
  """
  alias Covid19.Repo
  alias Covid19.Schema.{DailyData, DailyDataUS}

  import Ecto.Query

  def dates_not_loaded(%Date{} = date, type), do: dates_not_loaded([date], type)

  def dates_not_loaded(dates, type) when is_list(dates) do
    dates
    |> MapSet.new()
    |> MapSet.difference(dates_loaded(type))
  end

  def dates_loaded(type) do
    type
    |> get_schema()
    |> distinct([:date])
    |> select([r], r.date)
    |> Repo.all()
    |> MapSet.new()
  end

  defp get_schema(:global), do: DailyData
  defp get_schema(:us), do: DailyDataUS
end
