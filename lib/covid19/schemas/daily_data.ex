defmodule Covid19.Schemas.DailyData do
  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset

  schema "daily_data" do
    field :active, :integer
    field :case_fatality_ratio, :decimal
    field :confirmed, :integer
    field :country_or_region, :string
    field :county, :string
    field :date, :date
    field :deaths, :integer
    field :incidence_rate, :decimal
    field :latitude, :decimal
    field :longitude, :decimal
    field :province_or_state, :string
    field :recovered, :integer
    field :src, :string
    field :timestamp, :naive_datetime

    timestamps()
  end

  @fields ~w/
    active
    case_fatality_ratio
    confirmed
    country_or_region
    county
    date
    deaths
    incidence_rate
    latitude
    longitude
    province_or_state
    recovered
    src
    timestamp
  /a
  @required_fields ~w/country_or_region date src/a
  def changeset(daily_data, params) do
    daily_data
    |> cast(params, @fields)
    |> validate_required(@required_fields)
    |> unique_constraint([:country_or_region, :county, :province_or_state, :src])
  end

  def new, do: %__MODULE__{}
end
