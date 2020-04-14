defmodule Covid19.Repo.Migrations.CreateDailyDataTable do
  use Ecto.Migration

  import Ecto.Changeset

  def change do
    create table(:daily_data) do
      add :src, :string
      add :country_or_region, :string
      add :province_or_state, :string
      add :latitude, :decimal
      add :longitude, :decimal
      add :active, :integer
      add :confirmed, :integer
      add :deaths, :integer
      add :recovered, :integer
      add :timestamp, :naive_datetime

      timestamps()
    end
  end
end
