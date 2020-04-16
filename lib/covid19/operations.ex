defmodule Covid19.Operations do
  alias Covid19.DataSource.DailyCSV
  alias Covid19.Schemas.{DailyData, DailyDataUS}
  alias Covid19.Repo
  alias Ecto.Multi

  import Ecto.Query

  @type dataset_types :: :us | :world

  @doc """
  Deletes all entries belonging to a date or a list of dates.
  """
  @spec delete(Date.t(), dataset_types) :: {non_neg_integer(), any()}
  def delete(%Date{} = date, :us), do: delete_by_dates([date], DailyDataUS)
  def delete(%Date{} = date, :world), do: delete_by_dates([date], DailyData)
  def delete(date, :us) when is_list(date), do: delete_by_dates(date, DailyDataUS)
  def delete(date, :world) when is_list(date), do: delete_by_dates(date, DailyData)

  defp delete_by_dates(dates, schema) when is_list(dates) do
    where(schema, [s], s.date in ^dates) |> Repo.delete_all()
  end

  def insert_daily_data(%Date{} = date, opts \\ []) do
    us? = opts[:us?] || false

    schema = (us? && DailyDataUS) || DailyData

    case DailyCSV.read(date, us?: us?) do
      :error ->
        {:error, :nofile}

      data ->
        data
        |> Enum.map(&%{changeset: schema.changeset(schema.new(), &1), uid: uid_of(&1)})
        |> Enum.with_index()
        |> Enum.reduce(%{uids: [], multi: Multi.new()}, fn {%{changeset: changeset, uid: uid},
                                                            idx},
                                                           %{uids: uids, multi: multi} = acc ->
          if uid in uids do
            acc
          else
            %{uids: [uid | uids], multi: Multi.insert(multi, to_string(idx), changeset)}
          end
        end)
        |> Map.get(:multi)
        |> Repo.transaction()
        |> case do
          {:ok, _} = result ->
            result

          {:error, multi_key, changeset, _} ->
            {:error, multi_key,
             Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
               Enum.reduce(opts, msg, fn {key, value}, acc ->
                 String.replace(acc, "#{multi_key}: %{#{key}}", to_string(value))
               end)
             end)}
        end
    end
  end

  defp uid_of(
         %{
           src: src,
           country_or_region: country_or_region,
           province_or_state: province_or_state
         } = data
       ) do
    county = (data[:county] && data.county) || "?"
    src <> country_or_region <> province_or_state <> county
  end
end
