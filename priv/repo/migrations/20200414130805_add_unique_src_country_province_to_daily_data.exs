defmodule Covid19.Repo.Migrations.AddUniqueSrcCountryProvinceToDailyData do
  use Ecto.Migration

  def change do
    create unique_index(:daily_data, [:src, :country_or_region, :province_or_state, :county])
  end
end
