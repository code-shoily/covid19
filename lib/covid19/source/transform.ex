defmodule Covid19.Source.Transform do
  @moduledoc """
  Transforms extracted data for loading
  """

  @decimal_keys ~w/
    case_fatality_ratio
    hospitalization_rate
    incidence_rate
    latitude
    longitude
    testing_rate
    total_rest_results
  /a

  @integer_keys ~w/
    active
    confirmed
    deaths
    people_hospitalized
    people_tested
    recovered
    total_test_results
  /a

  @doc """
  Converts daily data extract into a map with transformed fields.

  Countries are coerced into the `Country.all` country names, in case of
  missing name, the value is used as-is. Use functions from `Tools` module to
  check for any unhandled country and deal with them.

  Headings are fixed, any heading that is not handled in the heading map will
  raise an exception.
  """
  @spec daily_data_to_map([[binary()]]) :: [map()]
  def daily_data_to_map([headers | rows]) when is_list(rows) do
    headers = Enum.map(headers, &heading/1)

    rows
    |> Enum.map(fn row ->
      row
      |> then(&Enum.zip(headers, &1))
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
    "\uFEFFFIPS" => :fips,
    "\uFEFFProvince/State" => :province_or_state,
    "Active" => :active,
    "Admin2" => :county,
    "Case_Fatality_Ratio" => :case_fatility_ratio,
    "Case-Fatality_Ratio" => :case_fatality_ratio,
    "Cases_28_Days" => :cases_28_days,
    "Combined_Key" => :combined_key,
    "Confirmed" => :confirmed,
    "Country_Region" => :country_or_region,
    "Country/Region" => :country_or_region,
    "Deaths_28_Days" => :deaths_28_days,
    "Deaths" => :deaths,
    "FIPS" => :fips,
    "Hospitalization_Rate" => :hospitalization_rate,
    "Incidence_Rate" => :incidence_rate,
    "Incident_Rate" => :incident_rate,
    "ISO3" => :iso3,
    "Last Update" => :timestamp,
    "Last_Update" => :timestamp,
    "Lat" => :latitude,
    "Latitude" => :latitude,
    "Long_" => :longitude,
    "Longitude" => :longitude,
    "Mortality_Rate" => :mortality_rate,
    "People_Hospitalized" => :people_hospitalized,
    "People_Tested" => :people_tested,
    "Province_State" => :province_or_state,
    "Province/State" => :province_or_state,
    "Recovered" => :recovered,
    "Testing_Rate" => :testing_rate,
    "Total_Test_Results" => :total_test_results,
    "UID" => :uid
  }

  defp heading(data), do: Map.fetch!(@global_headers, data)

  @country_or_region %{
    " Azerbaijan" => "Azerbaijan",
    "Bahamas, The" => "Bahamas",
    "Bolivia" => "Bolivia (Plurinational State of)",
    "Brunei" => "Brunei Darussalam",
    "Burma" => "Myanmar",
    "Cape Verde" => "Cabo Verde",
    "Channel Islands" => "Channel Islands",
    "Congo (Brazzaville)" => "Congo",
    "Congo (Kinshasa)" => "Congo (Democratic Republic of the)",
    "Cote d'Ivoire" => "Côte d'Ivoire",
    "Cruise Ship" => "Cruise Ship",
    "Curacao" => "Curaçao",
    "Czechia" => "Czech Republic",
    "Diamond Princess" => "Diamond Princess",
    "East Timor" => "Timor-Leste",
    "Eswatini" => "eSwatini",
    "Gambia, The" => "Gambia",
    "Hong Kong SAR" => "Hong Kong",
    "Iran" => "Iran (Islamic Republic of)",
    "Ivory Coast" => "Côte d'Ivoire",
    "Korea, South" => "Korea (Democratic People's Republic of)",
    "Kosovo" => "Kosovo",
    "Laos" => "Lao People's Democratic Republic",
    "Macao SAR" => "Macao",
    "Macau" => "Macao",
    "Mainland China" => "China",
    "Moldova" => "Moldova (Republic of)",
    "MS Zaandam" => "MS Zaandam",
    "North Ireland" => "United Kingdom of Great Britain and Northern Ireland",
    "North Macedonia" => "Macedonia (the former Yugoslav Republic of)",
    "occupied Palestinian territory" => "Palestine, State of",
    "Others" => "Others",
    "Palestine" => "Palestine, State of",
    "Republic of Ireland" => "Ireland",
    "Republic of Korea" => "Korea (Republic of)",
    "Republic of Moldova" => "Moldova (Republic of)",
    "Republic of the Congo" => "Congo",
    "Reunion" => "Réunion",
    "Russia" => "Russian Federation",
    "Saint Barthelemy" => "Saint Barthélemy",
    "Saint Martin" => "Saint Martin (French part)",
    "South Korea" => "Korea (Democratic People's Republic of)",
    "St. Martin" => "Saint Martin (French part)",
    "Summer Olympics 2020" => "Summer Olympics 2020",
    "Syria" => "Syrian Arab Republic",
    "Taipei and environs" => "Taiwan, Province of China",
    "Taiwan" => "Taiwan, Province of China",
    "Taiwan*" => "Taiwan, Province of China",
    "Tanzania" => "Tanzania, United Republic of",
    "The Bahamas" => "Bahamas",
    "The Gambia" => "Gambia",
    "UK" => "United Kingdom of Great Britain and Northern Ireland",
    "United Kingdom" => "United Kingdom of Great Britain and Northern Ireland",
    "US" => "United States of America",
    "Vatican City" => "Holy See",
    "Venezuela" => "Venezuela (Bolivarian Republic of)",
    "Vietnam" => "Viet Nam",
    "West Bank and Gaza" => "West Bank and Gaza"
  }

  defp country_or_region(data), do: Map.get(@country_or_region, data, data)
end
