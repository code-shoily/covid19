defmodule Covid19.Helpers.PathHelpers do
  @moduledoc """
  Helpers function for form paths and inspect directories.
  """

  @type path :: String.t()
  @type datasets :: :world | :us

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
  Returns the full path of the daily data file for `date`
  """
  @spec get_us_data_file(Date.t()) :: path()
  def get_us_data_file(%Date{} = date) do
    date
    |> date_to_string()
    |> full_us_path()
  end

  @doc """
  Lists all the dates for which the daily CSV file has been generated. Use `:us` to get the dates
  from the USA only reports and `:world` (default) for the world.

  This is useful to check in `iex` for availability of files and exploratory programming.
  """
  @spec dates(datasets) :: [Date.t()]
  def dates(dataset \\ :world) do
    case dataset do
      :world -> base_path()
      :us -> base_us_path()
    end
    |> File.ls!()
    |> Enum.sort()
    |> Enum.map(&filename_to_date/1)
    |> Enum.reject(&(&1 == :error))
  end

  defp date_to_string(date), do: Timex.format!(date, "%m-%d-%Y", :strftime)

  defp filename_to_date(filename) do
    with [filename, "csv"] <- String.split(filename, "."),
         {:ok, date} <- Timex.parse(filename, "%m-%d-%Y", :strftime) do
      NaiveDateTime.to_date(date)
    else
      _ -> :error
    end
  end

  defp base_path, do: Application.get_env(:covid19, :data_source)[:daily_dir]
  defp full_path(filename), do: "#{base_path()}/#{filename}.csv"

  defp base_us_path, do: Application.get_env(:covid19, :data_source)[:daily_dir_us]
  defp full_us_path(filename), do: "#{base_us_path()}/#{filename}.csv"
end
