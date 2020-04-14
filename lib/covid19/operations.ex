defmodule Covid19.Operations do
  alias Covid19.DataSource.DailyCSV
  alias Covid19.Schemas.{DailyData, DailyUSData}
  alias Covid19.Repo
  alias Ecto.Multi

  @spec insert_daily_data(Date.t(), [atom()]) ::
          {:ok, map()} | {:error, any(), Ecto.Changeset.t(), any()}
  def insert_daily_data(date, opts) do
    us? = opts[:us?] || false
    schema = (us? && DailyUSData) || DailyData

    date
    |> DailyCSV.read()
    |> Enum.map(&schema.changeset(schema.new(), &1))
    |> Enum.with_index()
    |> Enum.reduce(Multi.new(), fn {changeset, idx}, multi ->
      Multi.insert(multi, to_string(idx), changeset)
    end)
    |> Repo.transaction()
  end
end
