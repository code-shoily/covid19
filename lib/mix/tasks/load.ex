defmodule Mix.Tasks.Covid19.Load do
  @moduledoc ~S"""
  This is used to load data from CSV to DB. This processes the new CSV files that
  were not processed previously and inserts those to the database. For a particular
  date, you can add arguments in the format `<year> <month> <day>`

  #Usage

  ```
     mix covid19.load # Loads all data for dates not previously added
     mix covid19.load 2020 3 1 # Loads all data for March 1, 2020
  ```

  Attempting to load for data that already exists will result in error. In case
  you do not get valid data file, then either you have not pulled the latest file
  or data for that date does not exist.
  """

  use Mix.Task

  alias Covid19.{Operations, Queries}

  @usage_message "! Invalid arguments. Please input valid <year> <month> <day> or no argument"

  @shortdoc "Load data from CSV into DB Table"
  def run(args) do
    Mix.Task.run("app.start", [])

    case args do
      [_, _, _] -> load_for_date(args)
      _ -> load_all_new()
    end
  end

  defp load_for_date([_, _, _] = args) do
    [year, month, day] = Enum.map(args, &String.to_integer/1)
    date = %Date{year: year, month: month, day: day}
    print_response(Operations.insert_daily_data(date), date, "world")
    print_response(Operations.insert_daily_data(date, us?: true), date, "US")
  rescue
    _ ->
      Mix.shell().error(@usage_message)
  end

  defp load_all_new() do
    %{us: us_dates, world: world_dates} = Queries.unprocessed_dates()

    for date <- world_dates do
      print_response(Operations.insert_daily_data(date), date, "world")
    end

    for date <- us_dates do
      print_response(Operations.insert_daily_data(date, us?: true), date, "US")
    end
  end

  defp print_response(result, date, prefix) do
    case result do
      {:error, :nofile} ->
        Mix.shell().error(
          "! File (#{prefix}) does not exist for #{date}. Are you sure you have fetched the latest files?"
        )

      {:error, key, _} ->
        Mix.shell().error("! Error loading #{prefix} data for #{date} with key #{key}")

      {:ok, _} ->
        Mix.shell().info("* The #{prefix} data successfully loaded for #{date}")
    end
  end
end
