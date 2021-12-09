defmodule Covid19.Repo.Migrations.AddFipsIso3CombineedKeyToGlobalData do
  use Ecto.Migration

  def change do
    alter table(:daily_data) do
      add :combined_key, :string, null: true
      add :fips, :decimal, null: true
    end
  end
end
