defmodule Covid19.Repo do
  use Ecto.Repo,
    otp_app: :covid19,
    adapter: Ecto.Adapters.Postgres
end
