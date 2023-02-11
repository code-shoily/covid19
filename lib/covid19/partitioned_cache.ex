defmodule Covid19.PartitionedCache do
  use Nebulex.Cache,
    otp_app: :covid19,
    adapter: Nebulex.Adapters.Partitioned,
    primary_storage_adapter: Nebulex.Adapters.Local
end
