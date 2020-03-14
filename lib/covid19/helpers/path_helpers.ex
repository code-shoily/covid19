defmodule Covid19.Helpers.PathHelpers do
  @moduledoc """
  Helpers function for form paths and inspect directories.
  """
  @type path :: String.t()

  @doc """
  Returns the full path of the daily data file for `date`
  """
  @spec get_data_file(Date.t()) :: path()
  def get_data_file(%Date{} = date) do
    date
    |> date_to_string()
    |> full_path()
  end

  @doc """
  Lists all the dates for which the daily CSV file has been generated.

  This is useful to check in `iex` for availability of files and exploratory programming.
  """
  @spec dates :: [Date.t()]
  def dates do
    base_path()
    |> File.ls!()
    |> Enum.sort()
    |> Enum.map(&filename_to_date/1)
    |> Enum.reject(& &1 == :error)
  end

  defp date_to_string(date) do
    date
    |> Date.to_string()
    |> String.split("-")
    |> (fn [year, month, day] ->
          "#{month}-#{day}-#{year}"
        end).()
  end

  defp filename_to_date(filename) do
    with [filename, "csv"] <- String.split(filename, "."),
         [month, day, year] <- String.split(filename, "-"),
         {month, _} <- Integer.parse(month),
         {day, _} <- Integer.parse(day),
         {year, _} <- Integer.parse(year) do
      %Date{year: year, month: month, day: day}
    else
      _ -> :error
    end
  end

  defp base_path(), do: Application.get_env(:covid19, :data_source)[:daily_dir]

  defp full_path(filename) do
    "#{base_path()}/#{filename}.csv"
  end
end
