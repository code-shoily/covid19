defmodule Mix.Tasks.Covid19.Delete do
  @moduledoc ~S"""
  This is used to delete data for a particular date from the database.

  Arguments in the format `<year> <month> <day>`

  #Usage

  ```
     mix covid19.delete 2020 3 1 # Deletes all data for March 1, 2020
  ```
  """

  use Mix.Task

  alias Covid19.Operations

  @usage_message "! Invalid arguments. Please input valid <year> <month> <day> or no argument"

  @shortdoc "Delete data from CSV into DB Table"
  def run([_, _, _] = args) do
    Mix.Task.run "app.start", []

    [year, month, day] = Enum.map(args, &String.to_integer/1)
    date = %Date{year: year, month: month, day: day}
    print_response(Operations.delete(date, :world), date, "world")
    print_response(Operations.delete(date, :us), date, "US")
  rescue
    _ ->
      Mix.shell.error(@usage_message)
  end


  defp print_response(result, date, prefix) do
    case result do
      {0, _} ->
        Mix.shell.error("! No rows were removed for #{prefix} of #{date}")

      {n, _} ->
        Mix.shell.info("* #{n} rows were delete for #{prefix} data of #{date}")
    end
  end
end
