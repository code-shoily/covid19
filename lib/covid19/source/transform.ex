defmodule Covid19.Source.Transform do
  @moduledoc """
  Transforms extracted data for loading
  """
  @integer_keys ~w/
    active
    confirmed
    deaths
    recovered
    people_tested
    people_hospitalized
    total_test_results
  /a

  @decimal_keys ~w/
    latitude
    longitude
    case_fatality_ratio
    incidence_rate
    testing_rate
    hospitalization_rate
    total_rest_results
  /a
  def daily_data_to_map([headers | rows]) do
    headers = Enum.map(headers, &heading/1)

    rows
    |> Enum.map(fn row ->
      row
      |> then(fn row -> Enum.zip(headers, row) end)
      |> Enum.into(%{})
      |> Map.map(fn
        {:country_or_region, country} -> country_or_region(country)
        {:timestamp, timestamp} -> to_datetime!(timestamp)
        {key, value} when key in @integer_keys -> to_integer(value)
        {key, value} when key in @decimal_keys -> to_decimal(value)
        {_, column} -> column
      end)
    end)
  end

  defp to_integer(number) when is_binary(number) do
    case Integer.parse(number) do
      {number, _} -> number
      :error -> nil
    end
  end

  defp to_integer(nil), do: nil

  defp to_decimal(number) when is_binary(number) do
    case Decimal.parse(number) do
      {number, ""} -> number
      _ -> nil
    end
  end

  defp to_datetime!(str) do
    case to_datetime(str) do
      {:ok, date} -> date
      _ -> raise "Invalid date format"
    end
  end

  defp to_datetime(""), do: {:ok, nil}

  defp to_datetime(str) do
    case Timex.parse(str, "{ISO:Extended}") do
      {:ok, _} = date -> date
      {:error, _} -> Timex.parse(format_date(str), "%m/%d/%y %R", :strftime)
    end
  end

  defp format_date(date_str) do
    with [date, time] <- String.split(date_str, " "),
         [month, day, year] <- String.split(date, "/") do
      month = String.pad_leading(month, 2, "0")
      day = String.pad_leading(day, 2, "0")

      year =
        case String.split_at(year, 2) do
          {two_digit, ""} -> two_digit
          {_, four_digit} -> four_digit
        end

      "#{month}/#{day}/#{year} #{time}"
    end
  end

  @global_headers %{
    "Admin2" => :county,
    "Active" => :active,
    "Combined_Key" => :combined_key,
    "Confirmed" => :confirmed,
    "Country/Region" => :country_or_region,
    "Country_Region" => :country_or_region,
    "Deaths" => :deaths,
    "FIPS" => :fips,
    "\uFEFFFIPS" => :fips,
    "Last Update" => :timestamp,
    "Last_Update" => :timestamp,
    "Recovered" => :recovered,
    "\uFEFFProvince/State" => :province_or_state,
    "Province/State" => :province_or_state,
    "Province_State" => :province_or_state,
    "Latitude" => :latitude,
    "Lat" => :latitude,
    "Longitude" => :longitude,
    "Long_" => :longitude,
    "Incidence_Rate" => :incidence_rate,
    "Case-Fatality_Ratio" => :case_fatality_ratio,
    "Case_Fatality_Ratio" => :case_fatility_ratio,
    "Incident_Rate" => :incident_rate,
    "People_Tested" => :people_tested,
    "People_Hospitalized" => :people_hospitalized,
    "Mortality_Rate" => :mortality_rate,
    "UID" => :uid,
    "ISO3" => :iso3,
    "Testing_Rate" => :testing_rate,
    "Hospitalization_Rate" => :hospitalization_rate,
    "Total_Test_Results" => :total_test_results,
    "Cases_28_Days" => :cases_28_days,
    "Deaths_28_Days" => :deaths_28_days
  }

  defp heading(extracted_heading), do: Map.fetch!(@global_headers, extracted_heading)

  @country_or_region %{
    " Azerbaijan" => "Azerbaijan",
    "Bolivia" => "Bolivia (Plurinational State of)",
    "Brunei" => "Brunei Darussalam",
    "Congo (Kinshasa)" => "Congo (Democratic Republic of the)",
    "Channel Islands" => "Channel Islands",
    "Cote d'Ivoire" => "Côte d'Ivoire",
    "Ivory Coast" => "Côte d'Ivoire",
    "Czechia" => "Czech Republic",
    "Vatican City" => "Holy See",
    "Hong Kong SAR" => "Hong Kong",
    "Republic of Ireland" => "Ireland",
    "South Korea" => "Korea (Democratic People's Republic of)",
    "Iran" => "Iran (Islamic Republic of)",
    "Korea, South" => "Korea (Democratic People's Republic of)",
    "Republic of Korea" => "Korea (Republic of)",
    "Macao SAR" => "Macao",
    "Macau" => "Macao",
    "North Macedonia" => "Macedonia (the former Yugoslav Republic of)",
    "Moldova" => "Moldova (Republic of)",
    "Republic of Moldova" => "Moldova (Republic of)",
    "Mainland China" => "China",
    "North Ireland" => "United Kingdom of Great Britain and Northern Ireland",
    "occupied Palestinian territory" => "Palestine, State of",
    "Palestine" => "Palestine, State of",
    "Reunion" => "Réunion",
    "Russia" => "Russian Federation",
    "Saint Barthelemy" => "Saint Barthélemy",
    "Saint Martin" => "Saint Martin (French part)",
    "St. Martin" => "Saint Martin (French part)",
    "Taiwan" => "Taiwan, Province of China",
    "Taiwan*" => "Taiwan, Province of China",
    "Taipei and environs" => "Taiwan, Province of China",
    "UK" => "United Kingdom of Great Britain and Northern Ireland",
    "United Kingdom" => "United Kingdom of Great Britain and Northern Ireland",
    "US" => "United States of America",
    "Vietnam" => "Viet Nam",
    "Bahamas, The" => "Bahamas",
    "Burma" => "Myanmar",
    "Cape Verde" => "Cabo Verde",
    "Congo (Brazzaville)" => "Congo",
    "Cruise Ship" => "Cruise Ship",
    "Curacao" => "Curaçao",
    "Diamond Princess" => "Diamond Princess",
    "East Timor" => "Timor-Leste",
    "Eswatini" => "eSwatini",
    "Gambia, The" => "Gambia",
    "Kosovo" => "Kosovo",
    "Laos" => "Lao People's Democratic Republic",
    "MS Zaandam" => "MS Zaandam",
    "Others" => "Others",
    "Republic of the Congo" => "Congo",
    "Syria" => "Syrian Arab Republic",
    "Tanzania" => "Tanzania, United Republic of",
    "The Bahamas" => "Bahamas",
    "The Gambia" => "Gambia",
    "Venezuela" => "Venezuela (Bolivarian Republic of)",
    "West Bank and Gaza" => "West Bank and Gaza",
    "Summer Olympics 2020" => "Summer Olympics 2020"
  }

  defp country_or_region(extracted_contry_or_region),
    do: Map.fetch!(@country_or_region, extracted_contry_or_region)
end
