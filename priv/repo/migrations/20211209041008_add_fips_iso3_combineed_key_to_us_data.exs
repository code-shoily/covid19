defmodule Covid19.Repo.Migrations.AddFipsIso3CombineedKeyToUsData do
  use Ecto.Migration

  def change do
    alter table(:daily_data_us) do
      add :iso3, :string, null: true
      add :fips, :string, null: true
    end
  end
end
