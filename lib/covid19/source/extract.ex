defmodule Covid19.Source.Extract do
  @moduledoc """
  Extracts data from CSV sources
  """

  alias Covid19.Source.PathHelpers, as: Helpers
  alias NimbleCSV.RFC4180, as: ResourceParser

  @global_map %{
    "Case-Fatality_Ratio" => "case_fatality_ratio",
    "Case_Fatality_Ratio" => "case_fatality_ratio",
    "Confirmed" => "confirmed",
    "Country/Region" => "country_or_region",
    "Country_Region" => "country_or_region",
    "Deaths" => "deaths",
    "Incidence_Rate" => "incidence_rate",
    "Incident_Rate" => "incidence_rate",
    "Last Update" => "timestamp",
    "Last_Update" => "timestamp",
    "Lat" => "latitude",
    "Latitude" => "latitude",
    "Long_" => "longitude",
    "Longitude" => "longitude",
    "Province/State" => "province_or_state",
    "Province_State" => "province_or_state",
    # Non-DB
    "Active" => "Active",
    "Admin2" => "Admin2",
    "Combined_Key" => "Combined_Key",
    "FIPS" => "FIPS",
    "Recovered" => "Recovered"
  }

  @global_headers [
    "case_fatality_ratio",
    "case_fatality_ratio",
    "confirmed",
    "country_or_region",
    "country_or_region",
    "deaths",
    "incidence_rate",
    "incidence_rate",
    "timestamp",
    "timestamp",
    "latitude",
    "latitude",
    "longitude",
    "longitude",
    "province_or_state",
    "province_or_state"
  ]

  @us_map %{
    "Active" => "active",
    "Case_Fatality_Ratio" => "case_fatality_ratio",
    "Cases_28_Days" => "cases_28_days",
    "Confirmed" => "confirmed",
    "Country_Region" => "country_region",
    "Deaths" => "deaths",
    "Deaths_28_Days" => "deaths_28_days",
    "Hospitalization_Rate" => "hospitalization_rate",
    "Incident_Rate" => "incident_rate",
    "Last_Update" => "timestamp",
    "Lat" => "latitude",
    "Long_" => "longitude",
    "Mortality_Rate" => "mortality_rate",
    "People_Hospitalized" => "people_hospitalized",
    "People_Tested" => "people_tested",
    "Province_State" => "province_or_state",
    "Recovered" => "recovered",
    "Testing_Rate" => "testing_rate",
    "Total_Test_Results" => "total_test_results",
    "FIPS" => "FIPS",
    "ISO3" => "ISO3",
    "UID" => "UID"
  }

  @us_headers [
    "Active",
    "Case_Fatality_Ratio",
    "Cases_28_Days",
    "Confirmed",
    "Country_Region",
    "Deaths",
    "Deaths_28_Days",
    "Hospitalization_Rate",
    "Incident_Rate",
    "Last_Update",
    "Lat",
    "Long_",
    "Mortality_Rate",
    "People_Hospitalized",
    "People_Tested",
    "Province_State",
    "Recovered",
    "Testing_Rate",
    "Total_Test_Results"
  ]

  @doc """
  Sources daily data from the world data source. Returns the validated data with the desired field and types casted to desired ones.
  """
  def daily_global_data(date) do
    read_daily_data(
      date,
      Helpers.global_resources(),
      &cast(&1, :global),
      &take(&1, :global)
    )
  end

  def daily_us_data(date) do
    read_daily_data(
      date,
      Helpers.us_resources(),
      &cast(&1, :us),
      &take(&1, :us)
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

  defp cast(csv_headers, :global), do: do_cast(csv_headers, @global_map)
  defp cast(csv_headers, :us), do: do_cast(csv_headers, @us_map)

  defp take(csv_map, :global), do: do_take(csv_map, @global_headers)
  defp take(csv_map, :us), do: do_take(csv_map, @us_headers)

  defp do_cast(csv_headers, map) do
    csv_headers
    # This should loudly fail in case a new column appears in a future CSV
    |> Enum.map(fn header -> map[header] end)
    |> Enum.reject(&is_nil/1)
  end

  defp do_take(csv_map, columns) do
    csv_map |> Map.take(columns)
  end
end
