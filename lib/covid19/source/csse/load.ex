defmodule Covid19.Source.CSSE.Load do
  @moduledoc """
  Loads data into store.
  """
  @type types() :: :global | :us

  @doc """
  Inserts all data into either global or us table.
  """
  @spec insert([map()], types()) :: {[map()], types()}
  def insert(data, source) do
    {source, data}
  end
end
