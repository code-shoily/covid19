defmodule Covid19.Repo.Migrations.CreateDailyDataUs do
  use Ecto.Migration

  import Ecto.Changeset

  def change do
    create table(:daily_data_us) do
      add :uid, :string
      add :src, :string, null: false
      add :date, :date, null: false
      add :country_or_region, :string
      add :province_or_state, :string
      add :latitude, :decimal
      add :longitude, :decimal
      add :active, :integer
      add :confirmed, :integer
      add :recovered, :integer
      add :deaths, :integer
      add :people_tested, :integer
      add :people_hospitalized, :integer
      add :incident_rate, :decimal
      add :testing_rate, :decimal
      add :hospitalization_rate, :decimal
      add :mortality_rate, :decimal
      add :timestamp, :naive_datetime

      timestamps()
    end

    create unique_index(:daily_data_us, [:src, :uid])
  end
end
