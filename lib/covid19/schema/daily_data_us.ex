defmodule Covid19.Schema.DailyDataUS do
  @moduledoc """
  Schema for daily datasets for US.
  """

  use Ecto.Schema

  schema "daily_data_us" do
    field :active, :integer
    field :cases_28_days, :decimal
    field :case_fatality_ratio, :decimal
    field :confirmed, :integer
    field :country_or_region, :string
    field :date, :date
    field :deaths_28_days, :decimal
    field :deaths, :integer
    field :fips, :decimal
    field :hospitalization_rate, :decimal
    field :incidence_rate, :decimal
    field :iso3, :string
    field :latitude, :decimal
    field :longitude, :decimal
    field :mortality_rate, :decimal
    field :people_hospitalized, :integer
    field :people_tested, :integer
    field :province_or_state, :string
    field :recovered, :integer
    field :src, :string
    field :testing_rate, :decimal
    field :timestamp, :naive_datetime
    field :total_test_results, :decimal
    field :uid, :string

    timestamps()
  end
end
