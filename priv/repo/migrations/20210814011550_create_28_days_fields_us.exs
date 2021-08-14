defmodule Covid19.Repo.Migrations.Create28DaysFieldsUs do
  use Ecto.Migration

  def change do
    alter table(:daily_data_us) do
      add :cases_28_days, :decimal, null: true
      add :deaths_28_days, :decimal, null: true
    end
  end
end
