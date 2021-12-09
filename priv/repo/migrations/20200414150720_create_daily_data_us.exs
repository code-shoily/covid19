defmodule Covid19.Repo.Migrations.CreateDailyDataUs do
  use Ecto.Migration

  import Ecto.Changeset

  def change do
    create table(:daily_data_us) do
      add :active, :integer
      add :case_fatality_ratio, :decimal, null: true
      add :confirmed, :integer
      add :country_or_region, :string
      add :date, :date, null: false
      add :deaths, :integer
      add :hospitalization_rate, :decimal
      add :incidence_rate, :decimal
      add :latitude, :decimal
      add :longitude, :decimal
      add :mortality_rate, :decimal
      add :people_hospitalized, :integer
      add :people_tested, :integer
      add :province_or_state, :string
      add :recovered, :integer
      add :src, :string, null: false
      add :testing_rate, :decimal
      add :timestamp, :naive_datetime
      add :uid, :string

      timestamps()
    end

    create unique_index(:daily_data_us, [:src, :uid])
  end
end
