defmodule Covid19.Repo.Migrations.UpdateTimestampsToTakeDefault do
  use Ecto.Migration

  def change do
    alter table(:daily_data) do
      modify :inserted_at, :utc_datetime, default: fragment("NOW()")
      modify :updated_at, :utc_datetime, default: fragment("NOW()")
    end

    alter table(:daily_data_us) do
      modify :inserted_at, :utc_datetime, default: fragment("NOW()")
      modify :updated_at, :utc_datetime, default: fragment("NOW()")
    end
  end
end
