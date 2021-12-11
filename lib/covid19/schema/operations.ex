defmodule Covid19.Schema.Operations do
  @moduledoc """
  All database mutation functions.
  """
  alias Covid19.Queries.Summary
  alias Covid19.Repo
  alias Covid19.Schema.{DailyData, DailyDataUS}

  import Ecto.Query

  @doc """
  Deletes all the data that has `dates`.
  """
  @spec delete_daily_data([Date.t()], :global | :us) :: any()
  def delete_daily_data(date, :global), do: do_delete_daily_data(date, DailyData)
  def delete_daily_data(date, :us), do: do_delete_daily_data(date, DailyDataUS)

  defp do_delete_daily_data(dates, schema) do
    schema
    |> where([row], row.date in ^dates)
    |> Repo.delete_all()
  end
end
