defmodule Covid19.Source.Load do
  @moduledoc """
  Loads data into store.
  """
  alias Covid19.Repo
  alias Covid19.Schema.{DailyData, DailyDataUS}

  @doc """
  Inserts all data into either global or us table.

  * data - data map received from `Transform`
  * type - dataset type either :us or :global

  """
  @spec insert(map() | nil, type :: :us | :global) :: {integer(), any()}
  def insert(nil, _), do: {0, nil}
  def insert(data, :global), do: insert_all(DailyData, data)
  def insert(data, :us), do: insert_all(DailyDataUS, data)

  defp insert_all(schema, data), do: Repo.insert_all(schema, Enum.uniq(data))
end
