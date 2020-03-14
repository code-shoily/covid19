defmodule Covid19.Repo.Migrations.CreateDailyDataTable do
  use Ecto.Migration

  import Ecto.Changeset

  def change do
    create table(:daily_data) do
      add :country_or_region, :string
      add :province_or_state, :string
      add :confirmed, :integer
      add :deaths, :integer
      add :recovered, :integer
      add :timestamp, :naive_datetime

      timestamps()
    end
  end

  @fields ~w/
    country_or_region
    province_or_state
    confirmed
    deaths
    recovered
    timestamp
  /a
  def changeset(schema, params) do
    schema
    |> cast(params, @fields)
  end
end
