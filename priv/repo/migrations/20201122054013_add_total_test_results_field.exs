defmodule Covid19.Repo.Migrations.AddTotalTestResultsField do
  use Ecto.Migration

  def change do
    alter table(:daily_data_us) do
      add :total_test_results, :decimal, null: true
    end
  end
end
