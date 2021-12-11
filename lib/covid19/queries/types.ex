defmodule Covid19.Queries.Types do
  @moduledoc """
  Type specifications for all data
  """

  @typedoc """
  Name of a country
  """
  @type country_name :: String.t()

  @typedoc """
  Information of summary data for country
  """
  @type country_type :: %{
          required(:confirmed) => integer(),
          required(:country_or_region) => String.t(),
          required(:deaths) => integer(),
          required(:new_confirmed) => integer(),
          required(:new_deaths) => integer()
        }

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
  @type world_summary_type :: %{
          required(:active) => non_neg_integer(),
          required(:confirmed) => non_neg_integer(),
          required(:date) => Date.t(),
          required(:deaths) => non_neg_integer(),
          required(:recovered) => non_neg_integer()
        }

  @typedoc """
  Country summary data
  """
  @type country_summary_type :: %{
          required(:active) => integer(),
          required(:confirmed) => integer(),
          required(:deaths) => integer(),
          required(:new_confirmed) => integer(),
          required(:new_deaths) => integer(),
          required(:new_recovered) => integer(),
          required(:recovered) => integer()
        }
end
