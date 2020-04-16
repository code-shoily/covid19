defmodule Covid19.Queries do
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

  @moduledoc """
  Returns the dates for which data was processed
  """
  @spec processed_dates(datasets) :: maybe_dates()
  def processed_dates(:world), do: get_unique_dates(DailyData)

  def processed_dates(:us), do: get_unique_dates(DailyDataUS)

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
end
