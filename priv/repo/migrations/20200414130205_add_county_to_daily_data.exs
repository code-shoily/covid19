defmodule Covid19.Repo.Migrations.AddCountyToDailyData do
  use Ecto.Migration

  def change do
    alter table(:daily_data) do
      add :county, :string, default: ""
    end
  end
end
