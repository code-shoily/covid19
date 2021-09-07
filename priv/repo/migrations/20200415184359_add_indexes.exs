defmodule Covid19.Repo.Migrations.AddIndexes do
  use Ecto.Migration

  def change do
    create index(:daily_data, [:date])
    create index(:daily_data, [:country_or_region])
    create index(:daily_data, [:date, :country_or_region])
    create index(:daily_data_us, [:date])
    create index(:daily_data_us, [:country_or_region])
    create index(:daily_data_us, [:date, :country_or_region])
  end
end
