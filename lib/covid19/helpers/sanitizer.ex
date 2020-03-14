defmodule Covid19.Helpers.Sanitizer do
  @moduledoc """
  Function(s) to sanitize contents in CSV and perform corrections to
  ensure uniformity.
  """
  @type heading ::
          :confirmed
          | :country
          | :deaths
          | :updated_at
          | :recovered
          | :province_or_state
          | :latitude
          | :longitude

  @doc """
  Translates heading names found in the file into standard keys.
  """
  @spec sanitize_heading(String.t()) :: heading
  def sanitize_heading("Confirmed"), do: :confirmed
  def sanitize_heading("Country/Region"), do: :country
  def sanitize_heading("Deaths"), do: :deaths
  def sanitize_heading("Last Update"), do: :updated_at
  def sanitize_heading("Recovered"), do: :recovered
  def sanitize_heading("\uFEFFProvince/State"), do: :province_or_state
  def sanitize_heading("Province/State"), do: :province_or_state
  def sanitize_heading("Latitude"), do: :latitude
  def sanitize_heading("Longitude"), do: :longitude
end
