defmodule Covid19.DataSource.DailyCSV do
  @moduledoc """
  Functions to read from the CSV daily reports.
  """

  alias Covid19.Helpers.{PathHelpers, Sanitizer}

  @typep value() :: String.t()
  @type row :: %{
          required(:confirmed) => value(),
          required(:country) => value(),
          required(:deaths) => value(),
          required(:recovered) => value(),
          required(:province_or_state) => value(),
          optional(:latitude) => value(),
          optional(:longitude) => value()
        } | [value()]
  @type parsed_content :: [row()]

  @doc """
  Read from a single CSV file. It takes a `Date` as input.

  Returns a list of map with the heading items of the CSV as keys.
  """
  @spec read(Date.t(), boolean()) :: parsed_content()
  def read(%Date{} = date, sanitized? \\ true) do
    with path <- PathHelpers.get_data_file(date),
         true <- File.exists?(path) do
      data =
        path
        |> File.stream!()
        |> CSV.decode!()
        |> Enum.to_list()

      (sanitized? && as_map(data)) || data
    else
      false -> {:error, :nofile}
    end
  end

  @doc """
  Reads all files and stores them as a single list
  """
  @spec read_all(boolean()) :: [parsed_content()]
  def read_all(sanitized? \\ true) do
    PathHelpers.dates()
    |> Enum.map(&read(&1, sanitized?))
  end

  defp as_map([heading | body]) do
    heading = Enum.map(heading, &Sanitizer.sanitize_heading/1)
    body = Enum.map(body, fn row -> Enum.map(row, &String.trim/1) end)

    body
    |> Enum.map(fn row ->
      Enum.zip(heading, row) |> Enum.into(%{})
    end)
  end
end
