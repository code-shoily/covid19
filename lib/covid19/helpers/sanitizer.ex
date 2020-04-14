defmodule Covid19.Helpers.Sanitizer do
  @moduledoc """
  Function(s) to sanitize contents in CSV and perform corrections to
  ensure uniformity.
  """
  @type heading ::
          :admin
          | :active
          | :confirmed
          | :country
          | :deaths
          | :fips
          | :timestamp
          | :recovered
          | :province_or_state
          | :latitude
          | :longitude

  @doc """
  Translates heading names found in the file into standard keys.
  """
  @spec sanitize_heading(String.t()) :: heading
  def sanitize_heading("Admin2"), do: :admin
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

  # TODO: Sort these things!
  @doc """
  Translates country names found in the file into standard country names.
  """
  def sanitize_country("Bolivia"), do: "Bolivia (Plurinational State of)"
  def sanitize_country("Brunei"), do: "Brunei Darussalam"
  def sanitize_country("Congo (Kinshasa)"), do: "Congo (Democratic Republic of the)"
  def sanitize_country("Cote d'Ivoire"), do: "Côte d'Ivoire"
  def sanitize_country("Ivory Coast"), do: "Côte d'Ivoire"
  def sanitize_country("Czechia"), do: "Czech Republic"
  def sanitize_country("Vatican City"), do: "Holy See"
  def sanitize_country("Hong Kong SAR"), do: "Hong Kong"
  def sanitize_country("Republic of Ireland"), do: "Ireland"
  def sanitize_country("South Korea"), do: "Korea (Democratic People's Republic of)"
  def sanitize_country("Iran"), do: "Iran (Islamic Republic of)"
  def sanitize_country("Korea, South"), do: "Korea (Democratic People's Republic of)"
  def sanitize_country("Republic of Korea"), do: "Korea (Republic of)"
  def sanitize_country("Macao SAR"), do: "Macao"
  def sanitize_country("Macau"), do: "Macao"
  def sanitize_country("North Macedonia"), do: "Macedonia (the former Yugoslav Republic of)"
  def sanitize_country("Moldova"), do: "Moldova (Republic of)"
  def sanitize_country("Republic of Moldova"), do: "Moldova (Republic of)"
  def sanitize_country("Mainland China"), do: "China"

  def sanitize_country("North Ireland"),
    do: "United Kingdom of Great Britain and Northern Ireland"

  def sanitize_country("occupied Palestinian territory"), do: "Palestine, State of"
  def sanitize_country("Palestine"), do: "Palestine, State of"
  def sanitize_country("Reunion"), do: "Réunion"
  def sanitize_country("Russia"), do: "Russian Federation"
  def sanitize_country("Saint Barthelemy"), do: "Saint Barthélemy"
  def sanitize_country("Saint Martin"), do: "Saint Martin (French part)"
  def sanitize_country("St. Martin"), do: "Saint Martin (French part)"
  def sanitize_country("Taiwan"), do: "Taiwan, Province of China"
  def sanitize_country("Taiwan*"), do: "Taiwan, Province of China"
  def sanitize_country("Taipei and environs"), do: "Taiwan, Province of China"
  def sanitize_country("UK"), do: "United Kingdom of Great Britain and Northern Ireland"

  def sanitize_country("United Kingdom"),
    do: "United Kingdom of Great Britain and Northern Ireland"

  def sanitize_country("US"), do: "United States of America"
  def sanitize_country("Vietnam"), do: "Viet Nam"
  def sanitize_country("Bahamas, The"), do: "Bahamas"
  def sanitize_country("Burma"), do: "Myanmar"
  def sanitize_country("Cape Verde"), do: "Cabo Verde"
  def sanitize_country("Congo (Brazzaville)"), do: "Congo"
  def sanitize_country("Cruise Ship"), do: "Cruise Ship"
  def sanitize_country("Curacao"), do: "Curaçao"
  def sanitize_country("East Timor"), do: "Timor-Leste"
  def sanitize_country("Eswatini"), do: "eSwatini"
  def sanitize_country("Gambia, The"), do: "Gambia"
  def sanitize_country("Laos"), do: "Lao People's Democratic Republic"
  def sanitize_country("MS Zaandam"), do: "MS Zaandam"
  def sanitize_country("Others"), do: "Others"
  def sanitize_country("Republic of the Congo"), do: "Congo"
  def sanitize_country("Syria"), do: "Syrian Arab Republic"
  def sanitize_country("Tanzania"), do: "Tanzania, United Republic of"
  def sanitize_country("The Bahamas"), do: "Bahamas"
  def sanitize_country("The Gambia"), do: "Gambia"
  def sanitize_country("Venezuela"), do: "Venezuela (Bolivarian Republic of)"
  def sanitize_country("West Bank and Gaza"), do: "West Bank and Gaza"

  def sanitize_country(country_region), do: country_region

  @doc """
  Coerces numeric data as integers
  """
  def coerce_integer(number) when is_binary(number) do
    case Integer.parse(number) do
      {number, _} -> number
      :error -> nil
    end
  end

  def coerce_integer(nil), do: nil

  @doc """
  Coerces numeric data as decimal
  """
  def coerce_decimal(number) when is_binary(number) do
    case Decimal.parse(number) do
      {:ok, number} -> number
      _ -> nil
    end
  end

  @doc """
  Converts str into `NaiveDateTime`, the file has two different formats of time,
  this one accommodates both.
  """
  def to_datetime(str) do
    case NaiveDateTime.from_iso8601(str) do
      {:ok, result} ->
        result

      _ ->
        with [date, time] <- String.split(str, " "),
             [month, day, year] <- String.split(date, "/"),
             [hour, minute] <- String.split(time, ":"),
             {year, _} <- Integer.parse(year),
             {month, _} <- Integer.parse(month),
             {day, _} <- Integer.parse(day),
             {hour, _} <- Integer.parse(hour),
             {minute, _} <- Integer.parse(minute) do
          %NaiveDateTime{
            year: year,
            month: month,
            day: day,
            hour: hour,
            minute: minute,
            second: 0
          }
        else
          _ -> :error
        end
    end
  end
end
