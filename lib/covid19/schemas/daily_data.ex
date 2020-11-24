defmodule Covid19.Schemas.DailyData do
  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset

  schema "daily_data" do
    field :src, :string
    field :date, :date
    field :country_or_region, :string
    field :province_or_state, :string
    field :county, :string
    field :latitude, :decimal
    field :longitude, :decimal
    field :active, :integer
    field :confirmed, :integer
    field :deaths, :integer
    field :recovered, :integer
    field :incidence_rate, :decimal
    field :case_fatality_ratio, :decimal
    field :timestamp, :naive_datetime

    timestamps()
  end

  @fields ~w/
    src country_or_region province_or_state county latitude
    longitude active confirmed deaths recovered timestamp date
    incidence_rate case_fatality_ratio
  /a
  @required_fields ~w/src country_or_region date/a
  def changeset(daily_data, params) do
    daily_data
    |> cast(params, @fields)
    |> validate_required(@required_fields)
    |> unique_constraint([:src, :country_or_region, :province_or_state, :county])
  end

  def new, do: %__MODULE__{}
end
