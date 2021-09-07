defmodule Covid19.Repo.Migrations.CreateIncidentFatality do
  use Ecto.Migration

  def change do
    alter table(:daily_data) do
      add :incidence_rate, :decimal, null: true
      add :case_fatality_ratio, :decimal, null: true
    end
  end
end
