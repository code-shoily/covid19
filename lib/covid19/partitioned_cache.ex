defmodule Covid19.PartitionedCache do
  @moduledoc """
  Cache (Partition) to be used for the app
  """
  use Nebulex.Cache,
    otp_app: :covid19,
    adapter: Nebulex.Adapters.Partitioned,
    primary_storage_adapter: Nebulex.Adapters.Local
end
