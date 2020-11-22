defmodule Covid19.Schemas.DailyDataUS do
  use Ecto.Schema

  import Ecto.Changeset

  schema "daily_data_us" do
    field :uid, :string
    field :src, :string
    field :date, :date
    field :country_or_region, :string
    field :province_or_state, :string
    field :latitude, :decimal
    field :longitude, :decimal
    field :active, :integer
    field :confirmed, :integer
    field :deaths, :integer
    field :recovered, :integer
    field :people_tested, :integer
    field :people_hospitalized, :integer
    field :incident_rate, :decimal
    field :testing_rate, :decimal
    field :hospitalization_rate, :decimal
    field :mortality_rate, :decimal
    field :timestamp, :naive_datetime
    field :total_test_results, :decimal

    timestamps()
  end

  @fields ~w/
    src country_or_region province_or_state latitude
    longitude active confirmed deaths recovered timestamp
    people_tested people_hospitalized testing_rate incident_rate
    hospitalization_rate mortality_rate uid date
  /a
  @required_fields ~w/src country_or_region date/a
  def changeset(daily_data, params) do
    daily_data
    |> cast(params, @fields)
    |> validate_required(@required_fields)
    |> unique_constraint([:src, :uid])
  end

  def new, do: %__MODULE__{}
end
