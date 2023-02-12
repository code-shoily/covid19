defmodule Covid19.TestCache do
  @moduledoc """
  TestCache is used as dummy cache so that it is not loaded during tests.
  """
  use Nebulex.Cache,
    otp_app: :covid19,
    adapter: Nebulex.Adapters.Nil
end
