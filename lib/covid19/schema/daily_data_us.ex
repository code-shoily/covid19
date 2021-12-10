defmodule Covid19.Schema.DailyDataUS do
  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset

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

  @fields ~w/
    active
    confirmed
    country_or_region
    date
    deaths
    fips
    hospitalization_rate
    incidence_rate
    iso3
    latitude
    longitude
    mortality_rate
    people_hospitalized
    people_tested
    province_or_state
    recovered
    src
    testing_rate
    timestamp
    uid
  /a
  @required_fields ~w/country_or_region date src/a
  def changeset(daily_data, params) do
    daily_data
    |> cast(params, @fields)
    |> validate_required(@required_fields)
    |> unique_constraint([:src, :uid])
  end

  def new, do: %__MODULE__{}
end
