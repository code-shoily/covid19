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
  @spec world_summary() :: %{required(Date.t()) => [world_summary_type()]}
  def world_summary() do
    DailyData
    |> group_by([e], e.date)
    |> select([e], %{
      date: e.date,
      deaths: sum(e.deaths),
      confirmed: sum(e.confirmed),
      recovered: sum(e.recovered)
    })
    |> order_by([e], e.date)
    |> Repo.all()
    |> Enum.map(&calculate_active/1)
    |> Enum.group_by(& &1.date)
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
end
