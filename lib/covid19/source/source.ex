defmodule Covid19.Source do
  @moduledoc """
  Functions to fetch data from source and updating the databases are here.
  """
  alias __MODULE__.{Extract, Load, Transform}
  alias Covid19.Queries.Common
  alias Covid19.Schema.Operations

  @type report_type :: :global | :us

  @doc """
  Syncs all data from source with the database.

  This function fetches all the data from John Hopkins dataset that belong and
  loads them into the database if and only if there exists no such entry in the
  database already.

  Please note: When loading for the first time, if the date range is large, then
  this could take upto 5 minutes to load.

  Normally, you would want to sync the data first with the source repository so
  that all the dates are available in CSV form. Then after running this code,
  this function will diff between the dates availalbe in CSVs with the dates
  available in the database and load them.

  Source Link: [CSSE Github](https://github.com/CSSEGISandData/COVID-19)
  """
  @spec sync_all :: %{global: integer(), us: integer()}
  def sync_all do
    %{global: sync_all(:global), us: sync_all(:us)}
  end

  @doc """
  Syncs all data from source with the database.

  * type - Either `:global` or `:us`. Indicates which source we are pulling.

  This function fetches all the data from John Hopkins dataset that belong and
  loads them into the database if and only if there exists no such entry in the
  database already.

  Please note: When loading for the first time, if the date range is large, then
  this could take upto 5 minutes to load.

  Normally, you would want to sync the data first with the source repository so
  that all the dates are available in CSV form. Then after running this code,
  this function will diff between the dates availalbe in CSVs with the dates
  available in the database and load them.

  Source Link: [CSSE Github](https://github.com/CSSEGISandData/COVID-19)
  """
  @spec sync_all(report_type()) :: integer()
  def sync_all(type) do
    dates = (type == :us && Extract.us_dates()) || Extract.global_dates()
    sync(dates, type)
  end

  @doc """
  Syncs the data for given dates with the source.

  * `dates` - Dates for which we are fetching the data
  * `type` - Either `:global` or `:us`. Indicates which source we are pulling.
  * `returns` - The total number of rows added

  This function fetches all the data from John Hopkins dataset that belong to
  the date and loads them into the database if and only if there exists no such
  entry in the database already.
  """
  @spec sync([Dates.t()], report_type()) :: integer()
  def sync(dates, type) when is_list(dates) do
    extract = (type == :us && (&Extract.us_data/1)) || (&Extract.global_data/1)

    for date <- dates_not_loaded(dates, type) do
      date
      |> extract.()
      |> Transform.daily_data_to_map()
      |> Load.insert(type)
    end
    |> Enum.reduce(0, fn {row, _}, rows -> rows + row end)
  end

  @doc """
  Rolls back the data by days mentioned.

  * `number_of_days` - number of days to roll back to. `last_day - day..last_day`
  * `type` - Either `:global` or `:us`. Indicates which source we are pulling.
  """
  @spec rollback(non_neg_integer(), report_type()) :: {integer(), any()}
  def rollback(number_of_days, type) do
    number_of_days
    |> latest_dates(type)
    |> Operations.delete_daily_data(type)
  end

  defp latest_dates(number_of_days, type) do
    number_of_days
    |> Common.latest(type)
    |> Enum.map(& &1.date)
  end

  defp dates_not_loaded(dates, type) when is_list(dates) do
    dates
    |> MapSet.new()
    |> MapSet.difference(Common.dates_loaded(type))
  end
end
