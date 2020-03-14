defmodule Covid19.Db.Schema do
  use Ecto.Schema

  schema "daily_data" do
    field :country_or_region, :string
    field :province_or_state, :string
    field :confirmed, :integer
    field :deaths, :integer
    field :recovered, :integer
    field :timestamp, :naive_datetime

    timestamps()
  end
end
