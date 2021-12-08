defmodule Covid19.Source.Extract do
  alias Covid19.Source.Helpers
  alias Covid19.Source.Headers
  alias NimbleCSV.RFC4180, as: ResourceParser

  @global_resources Helpers.global_resources()
  @us_resources Helpers.us_resources()

  @doc """
  Sources daily data from the world data source. Returns the validated data with the desired field and types casted to desired ones.
  """
  def daily_global_data(date) do
    read_daily_data(
      date,
      @global_resources,
      &Headers.cast(&1, :global),
      &Headers.take(&1, :global)
    )
  end

  def daily_us_data(date) do
    read_daily_data(
      date,
      @us_resources,
      &Headers.cast(&1, :us),
      &Headers.take(&1, :us)
    )
  end

  defp read_daily_data(date, resources, cast_headers, take_columns) do
    fixed_data = %{
      "date" => date,
      # It's okay to fail loudly if this is attempted
      "source" => resources[date]
    }

    resources
    |> Map.get(date)
    |> File.stream!()
    |> ResourceParser.parse_stream(skip_headers: false)
    |> Enum.to_list()
    |> then(fn [headers | data] ->
      headers = cast_headers.(headers)

      data
      |> Enum.map(fn row ->
        headers
        |> Enum.zip(row)
        |> Enum.into(%{})
        |> take_columns.()
        |> Map.merge(fixed_data)
      end)
    end)
  end
end
