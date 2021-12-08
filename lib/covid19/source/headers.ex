defmodule Covid19.Source.Headers do
  @moduledoc """
  Validators to validate and cast fields from CSV to Data Store
  """

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

  def cast(csv_headers, :global), do: do_cast(csv_headers, @global_map)
  def cast(csv_headers, :us), do: do_cast(csv_headers, @us_map)

  def take(csv_map, :global), do: do_take(csv_map, @global_headers)
  def take(csv_map, :us), do: do_take(csv_map, @us_headers)

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
