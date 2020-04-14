defmodule Covid19.DataSource.DailyCSV do
  @moduledoc """
  Functions to read from the CSV daily reports.
  """

  alias Covid19.Helpers.{PathHelpers, Sanitizer, Converters}

  @typep text() :: String.t() | nil
  @typep maybe_number() :: non_neg_integer() | nil
  @type row ::
          %{
            required(:active) => maybe_number(),
            required(:confirmed) => maybe_number(),
            required(:country_or_region) => text(),
            required(:deaths) => maybe_number(),
            required(:recovered) => maybe_number(),
            required(:province_or_state) => text(),
            optional(:latitude) => text(),
            optional(:longitude) => text(),
            optional(:timestamp) => text()
          }
          | [text()]
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

  @drop_keys ~w/fips combined_key admin/a
  defp as_map([heading | body]) do
    heading = Enum.map(heading, &Sanitizer.sanitize_heading/1)
    body = Enum.map(body, fn row -> Enum.map(row, &String.trim/1) end)

    body
    |> Enum.map(fn row ->
      Enum.zip(heading, row)
      |> Enum.into(%{})
      |> Map.update(:country_or_region, nil, &Sanitizer.sanitize_country/1)
      |> Map.update(:active, nil, &Converters.to_integer/1)
      |> Map.update(:confirmed, nil, &Converters.to_integer/1)
      |> Map.update(:deaths, nil, &Converters.to_integer/1)
      |> Map.update(:recovered, nil, &Converters.to_integer/1)
      |> Map.update(:latitude, nil, &Converters.to_decimal/1)
      |> Map.update(:longitude, nil, &Converters.to_decimal/1)
      |> Map.update(:timestamp, nil, &Converters.to_datetime!/1)
      |> Map.drop(@drop_keys)
    end)
  end
end
