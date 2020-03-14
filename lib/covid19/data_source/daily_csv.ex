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
  }

  @doc """
  Read from a single CSV file. It takes a `Date` as input.

  Returns a list of map with the heading items of the CSV as keys.
  """
  @spec read(Date.t()) :: [row()]
  def read(%Date{} = date \\ Date.utc_today()) do
    with path <- PathHelpers.get_data_file(date),
         true <- File.exists?(path) do
      path
      |> File.stream!()
      |> CSV.decode!()
      |> Enum.to_list()
      |> as_map()
    else
      false -> {:error, :nofile}
    end
  end

  defp as_map([heading | body]) do
    heading = Enum.map(heading, &Sanitizer.sanitize_heading/1)
    body
    |> Enum.map(fn row ->
      Enum.zip(heading, row) |> Enum.into(%{})
    end)
  end
end
