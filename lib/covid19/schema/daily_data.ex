defmodule Covid19.Schema.DailyData do
  @moduledoc """
  Schema for global daily datasets
  """

  use Ecto.Schema

  schema "daily_data" do
    field :active, :integer
    field :case_fatality_ratio, :decimal
    field :confirmed, :integer
    field :combined_key, :string
    field :country_or_region, :string
    field :county, :string
    field :date, :date
    field :deaths, :integer
    field :fips, :decimal
    field :incidence_rate, :decimal
    field :latitude, :decimal
    field :longitude, :decimal
    field :province_or_state, :string
    field :recovered, :integer
    field :src, :string
    field :timestamp, :naive_datetime

    timestamps()
  end
end
