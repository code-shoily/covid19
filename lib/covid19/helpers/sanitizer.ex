defmodule Covid19.Helpers.Sanitizer do
  @moduledoc """
  Function(s) to sanitize contents in CSV and perform corrections to
  ensure uniformity.
  """
  @type heading ::
          :admin
          | :uid
          | :iso3
          | :country_or_region
          | :province_or_state
          | :county
          | :fips
          | :latitude
          | :longitude
          | :active
          | :confirmed
          | :recovered
          | :deaths
          | :people_tested
          | :people_hospitalized
          | :incident_rate
          | :testing_rate
          | :hospitalization_rate
          | :mortality_rate
          | :timestamp
          | :incidence_rate
          | :case_fatality_ratio
          | :total_test_results

  @doc """
  Translates heading names found in the file into standard keys.
  """
  @spec sanitize_heading(String.t()) :: heading
  def sanitize_heading("Admin2"), do: :county
  def sanitize_heading("Active"), do: :active
  def sanitize_heading("Combined_Key"), do: :combined_key
  def sanitize_heading("Confirmed"), do: :confirmed
  def sanitize_heading("Country/Region"), do: :country_or_region
  def sanitize_heading("Country_Region"), do: :country_or_region
  def sanitize_heading("Deaths"), do: :deaths
  def sanitize_heading("FIPS"), do: :fips
  def sanitize_heading("\uFEFFFIPS"), do: :fips
  def sanitize_heading("Last Update"), do: :timestamp
  def sanitize_heading("Last_Update"), do: :timestamp
  def sanitize_heading("Recovered"), do: :recovered
  def sanitize_heading("\uFEFFProvince/State"), do: :province_or_state
  def sanitize_heading("Province/State"), do: :province_or_state
  def sanitize_heading("Province_State"), do: :province_or_state
  def sanitize_heading("Latitude"), do: :latitude
  def sanitize_heading("Lat"), do: :latitude
  def sanitize_heading("Longitude"), do: :longitude
  def sanitize_heading("Long_"), do: :longitude
  def sanitize_heading("Incidence_Rate"), do: :incidence_rate
  def sanitize_heading("Case-Fatality_Ratio"), do: :case_fatality_ratio
  def sanitize_heading("Case_Fatality_Ratio"), do: :case_fatility_ratio

  ## US ONLY FIELD
  def sanitize_heading("Incident_Rate"), do: :incident_rate
  def sanitize_heading("People_Tested"), do: :people_tested
  def sanitize_heading("People_Hospitalized"), do: :people_hospitalized
  def sanitize_heading("Mortality_Rate"), do: :mortality_rate
  def sanitize_heading("UID"), do: :uid
  def sanitize_heading("ISO3"), do: :iso3
  def sanitize_heading("Testing_Rate"), do: :testing_rate
  def sanitize_heading("Hospitalization_Rate"), do: :hospitalization_rate
  def sanitize_heading("Total_Test_Results"), do: :total_test_results
  def sanitize_heading("Cases_28_Days"), do: :cases_28_days
  def sanitize_heading("Deaths_28_Days"), do: :deaths_28_days

  @doc """
  Translates country names found in the file into country names that matches with `Countries` lib.
  """
  def sanitize_country_or_region("Bolivia"), do: "Bolivia (Plurinational State of)"
  def sanitize_country_or_region("Brunei"), do: "Brunei Darussalam"
  def sanitize_country_or_region("Congo (Kinshasa)"), do: "Congo (Democratic Republic of the)"
  def sanitize_country_or_region("Channel Islands"), do: "Channel Islands"
  def sanitize_country_or_region("Cote d'Ivoire"), do: "Côte d'Ivoire"
  def sanitize_country_or_region("Ivory Coast"), do: "Côte d'Ivoire"
  def sanitize_country_or_region("Czechia"), do: "Czech Republic"
  def sanitize_country_or_region("Vatican City"), do: "Holy See"
  def sanitize_country_or_region("Hong Kong SAR"), do: "Hong Kong"
  def sanitize_country_or_region("Republic of Ireland"), do: "Ireland"
  def sanitize_country_or_region("South Korea"), do: "Korea (Democratic People's Republic of)"
  def sanitize_country_or_region("Iran"), do: "Iran (Islamic Republic of)"
  def sanitize_country_or_region("Korea, South"), do: "Korea (Democratic People's Republic of)"
  def sanitize_country_or_region("Republic of Korea"), do: "Korea (Republic of)"
  def sanitize_country_or_region("Macao SAR"), do: "Macao"
  def sanitize_country_or_region("Macau"), do: "Macao"

  def sanitize_country_or_region("North Macedonia"),
    do: "Macedonia (the former Yugoslav Republic of)"

  def sanitize_country_or_region("Moldova"), do: "Moldova (Republic of)"
  def sanitize_country_or_region("Republic of Moldova"), do: "Moldova (Republic of)"
  def sanitize_country_or_region("Mainland China"), do: "China"

  def sanitize_country_or_region("North Ireland"),
    do: "United Kingdom of Great Britain and Northern Ireland"

  def sanitize_country_or_region("occupied Palestinian territory"), do: "Palestine, State of"
  def sanitize_country_or_region("Palestine"), do: "Palestine, State of"
  def sanitize_country_or_region("Reunion"), do: "Réunion"
  def sanitize_country_or_region("Russia"), do: "Russian Federation"
  def sanitize_country_or_region("Saint Barthelemy"), do: "Saint Barthélemy"
  def sanitize_country_or_region("Saint Martin"), do: "Saint Martin (French part)"
  def sanitize_country_or_region("St. Martin"), do: "Saint Martin (French part)"
  def sanitize_country_or_region("Taiwan"), do: "Taiwan, Province of China"
  def sanitize_country_or_region("Taiwan*"), do: "Taiwan, Province of China"
  def sanitize_country_or_region("Taipei and environs"), do: "Taiwan, Province of China"
  def sanitize_country_or_region("UK"), do: "United Kingdom of Great Britain and Northern Ireland"

  def sanitize_country_or_region("United Kingdom"),
    do: "United Kingdom of Great Britain and Northern Ireland"

  def sanitize_country_or_region("US"), do: "United States of America"
  def sanitize_country_or_region("Vietnam"), do: "Viet Nam"
  def sanitize_country_or_region("Bahamas, The"), do: "Bahamas"
  def sanitize_country_or_region("Burma"), do: "Myanmar"
  def sanitize_country_or_region("Cape Verde"), do: "Cabo Verde"
  def sanitize_country_or_region("Congo (Brazzaville)"), do: "Congo"
  def sanitize_country_or_region("Cruise Ship"), do: "Cruise Ship"
  def sanitize_country_or_region("Curacao"), do: "Curaçao"
  def sanitize_country_or_region("Diamond Princess"), do: "Diamond Princess"
  def sanitize_country_or_region("East Timor"), do: "Timor-Leste"
  def sanitize_country_or_region("Eswatini"), do: "eSwatini"
  def sanitize_country_or_region("Gambia, The"), do: "Gambia"
  def sanitize_country_or_region("Kosovo"), do: "Kosovo"
  def sanitize_country_or_region("Laos"), do: "Lao People's Democratic Republic"
  def sanitize_country_or_region("MS Zaandam"), do: "MS Zaandam"
  def sanitize_country_or_region("Others"), do: "Others"
  def sanitize_country_or_region("Republic of the Congo"), do: "Congo"
  def sanitize_country_or_region("Syria"), do: "Syrian Arab Republic"
  def sanitize_country_or_region("Tanzania"), do: "Tanzania, United Republic of"
  def sanitize_country_or_region("The Bahamas"), do: "Bahamas"
  def sanitize_country_or_region("The Gambia"), do: "Gambia"
  def sanitize_country_or_region("Venezuela"), do: "Venezuela (Bolivarian Republic of)"
  def sanitize_country_or_region("West Bank and Gaza"), do: "West Bank and Gaza"

  def sanitize_country_or_region(country_region), do: country_region
end
