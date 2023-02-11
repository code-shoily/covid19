defmodule Covid19.TestCache do
  use Nebulex.Cache,
    otp_app: :covid19,
    adapter: Nebulex.Adapters.Nil
end
