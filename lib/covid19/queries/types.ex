defmodule Covid19.Queries.Types do
  @moduledoc """
  Type specifications for all data
  """

  @typedoc """
  Name of a country
  """
  @type country_name :: String.t()

  @typedoc """
  Datasets - global or US
  """
  @type datasets :: :world | :us

  @typedoc """
  Date list or empty
  """
  @type maybe_dates :: [Date.t()] | []

  @typedoc """
  Global summary data
  """
  @type world_summary :: [
          %{
            required(:confirmed) => non_neg_integer(),
            required(:country_or_region) => non_neg_integer(),
            required(:date) => Date.t(),
            required(:deaths) => non_neg_integer(),
            required(:last_updated) => NaiveDateTime.t(),
            required(:new_confirmed) => non_neg_integer(),
            required(:new_deaths) => non_neg_integer(),
            required(:province_or_state) => non_neg_integer(),
            required(:src) => String.t()
          }
        ]

  @typedoc """
  Country summary data
  """
  @type country_summary :: [
          %{
            required(:confirmed) => non_neg_integer(),
            required(:country_or_region) => String.t(),
            required(:date) => Date.t(),
            required(:deaths) => non_neg_integer(),
            required(:new_confirmed) => non_neg_integer(),
            required(:new_deaths) => non_neg_integer(),
            required(:province_or_state) => non_neg_integer()
          }
        ]

  @typedoc """
  Province or state summary data
  """
  @type province_or_state_summary :: [
          %{
            required(:confirmed) => non_neg_integer(),
            required(:country_or_region) => String.t(),
            required(:date) => Date.t(),
            required(:deaths) => non_neg_integer(),
            required(:new_confirmed) => non_neg_integer(),
            required(:new_deaths) => non_neg_integer(),
            required(:province_or_state) => non_neg_integer()
          }
        ]

  @typedoc """
  Geolocation summary data
  """
  @type location_summary :: [
          %{
            required(:case_fatality_ratio) => non_neg_integer(),
            required(:confirmed) => non_neg_integer(),
            required(:country_or_region) => String.t(),
            required(:deaths) => non_neg_integer(),
            required(:incidence_rate) => non_neg_integer(),
            required(:latitude) => Decimal.t(),
            required(:longitude) => Decimal.t()
          }
        ]
end
