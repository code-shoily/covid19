defmodule Covid19.Source.CSSE.Load do
  @moduledoc """
  Loads data into store.
  """
  alias Covid19.Repo
  alias Covid19.Schemas.{DailyData, DailyDataUS}

  @type types() :: :global | :us

  @doc """
  Inserts all data into either global or us table.
  """
  def insert(data, :global), do: insert_all(DailyData, data)
  def insert(data, :us), do: insert_all(DailyDataUS, data)

  defp insert_all(schema, data), do: Repo.insert_all(schema, Enum.uniq(data))
end
