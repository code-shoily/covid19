defmodule Covid19.DataSource.DailyCSV do
  @moduledoc """
  Functions to read from the CSV daily reports.
  """

  alias Covid19.Helpers.{PathHelpers, Sanitizer, Converters}

  @typep text() :: String.t() | nil
  @typep maybe_number() :: non_neg_integer() | nil
  @typep maybe_decimal() :: Decimal.t() | nil
  @typep maybe_naive_datetime() :: NaiveDateTime.t() | nil

  @type sanitized_row ::
          %{
            required(:date) => Date.t(),
            optional(:uid) => text(),
            required(:country_or_region) => text(),
            required(:province_or_state) => text(),
            required(:county) => text(),
            optional(:latitude) => maybe_decimal(),
            optional(:longitude) => maybe_decimal(),
            optional(:active) => maybe_number(),
            required(:confirmed) => maybe_number(),
            required(:recovered) => maybe_number(),
            required(:deaths) => maybe_number(),
            optional(:people_tested) => maybe_number(),
            optional(:people_hospitalized) => maybe_number(),
            optional(:incident_rate) => maybe_decimal(),
            optional(:testing_rate) => maybe_decimal(),
            optional(:hospitalization_rate) => maybe_decimal(),
            optional(:mortality_rate) => maybe_decimal(),
            optional(:timestamp) => maybe_naive_datetime(),
            optional(:incidence_rate) => maybe_decimal(),
            optional(:case_fatality_ratio) => maybe_decimal()
          }
  @type unsanitized_row :: [text()]
  @type parsed_content :: [sanitized_row() | unsanitized_row()]

  @doc """
  Read from a single CSV file. It takes a `Date` as input.

  Returns a list of map with the heading items of the CSV as keys.
  """
  @spec read(Date.t(), any()) :: parsed_content() | :error
  def read(%Date{} = date, opts \\ []) do
    us? = opts[:us?] || false
    sanitized? = is_nil(opts[:sanitized?]) && true || opts[:sanitized?]

    with path <- get_file_path(date, us?),
         true <- File.exists?(path) do
      data =
        path
        |> File.stream!()
        |> CSV.decode!()
        |> Enum.to_list()

      (sanitized? && as_map(data, path, date)) || data
    else
      false -> :error
    end
  end

  defp get_file_path(date, false), do: PathHelpers.get_data_file(date)
  defp get_file_path(date, true), do: PathHelpers.get_us_data_file(date)

  @doc """
  Reads all files and stores them as a single list
  """
  @spec read_all([atom()]) :: [parsed_content()]
  def read_all(opts \\ []) do
    PathHelpers.dates()
    |> Enum.map(&read(&1, opts))
  end

  @drop_keys ~w/fips combined_key iso3/a
  defp as_map([heading | body], src, date) do
    heading = Enum.map(heading, &Sanitizer.sanitize_heading/1)
    body = Enum.map(body, fn row -> Enum.map(row, &String.trim/1) end)

    body
    |> Enum.map(fn row ->
      Enum.zip(heading, row)
      |> Enum.into(%{})
      |> Map.update(:country_or_region, nil, &Sanitizer.sanitize_country_or_region/1)
      |> Map.update(:active, nil, &Converters.to_integer/1)
      |> Map.update(:confirmed, nil, &Converters.to_integer/1)
      |> Map.update(:deaths, nil, &Converters.to_integer/1)
      |> Map.update(:recovered, nil, &Converters.to_integer/1)
      |> Map.update(:people_tested, nil, &Converters.to_integer/1)
      |> Map.update(:people_hospitalized, nil, &Converters.to_integer/1)
      |> Map.update(:incident_rate, nil, &Converters.to_decimal/1)
      |> Map.update(:mortality_rate, nil, &Converters.to_decimal/1)
      |> Map.update(:testing_rate, nil, &Converters.to_decimal/1)
      |> Map.update(:hospitalization_rate, nil, &Converters.to_decimal/1)
      |> Map.update(:latitude, nil, &Converters.to_decimal/1)
      |> Map.update(:longitude, nil, &Converters.to_decimal/1)
      |> Map.update(:timestamp, nil, &Converters.to_datetime!/1)
      |> Map.update(:incidence_rate, nil, &Converters.to_decimal/1)
      |> Map.update(:case_fatality_ratio, nil, &Converters.to_decimal/1)
      |> Map.put_new(:src, src)
      |> Map.put_new(:date, date)
      |> Map.drop(@drop_keys)
    end)
  end
end
