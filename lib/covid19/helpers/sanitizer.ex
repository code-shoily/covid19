defmodule Covid19.Helpers.Sanitizer do
  @moduledoc """
  Function(s) to sanitize contents in CSV and perform corrections to
  ensure uniformity.
  """
  @type heading ::
          :confirmed
          | :country
          | :deaths
          | :timestamp
          | :recovered
          | :province_or_state
          | :latitude
          | :longitude

  @doc """
  Translates heading names found in the file into standard keys.
  """
  @spec sanitize_heading(String.t()) :: heading
  def sanitize_heading("Confirmed"), do: :confirmed
  def sanitize_heading("Country/Region"), do: :country_or_region
  def sanitize_heading("Deaths"), do: :deaths
  def sanitize_heading("Last Update"), do: :timestamp
  def sanitize_heading("Recovered"), do: :recovered
  def sanitize_heading("\uFEFFProvince/State"), do: :province_or_state
  def sanitize_heading("Province/State"), do: :province_or_state
  def sanitize_heading("Latitude"), do: :latitude
  def sanitize_heading("Longitude"), do: :longitude

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

  def sanitize_country(country), do: country

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
