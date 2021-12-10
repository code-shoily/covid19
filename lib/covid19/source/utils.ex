defmodule Covid19.Source.Utils do
  @moduledoc """
  This module contains utilitiy functions that help with checking/validating.

  They are to be used in the REPL by the developer and not called by the app.
  """
  alias Covid19.Source.Extract
  alias Covid19.Source.Transform

  @doc """
  Find countries that are present on dataset but spelling does not match with
  country name in `Countries` module for a particujlar date
  """
  @spec missing_countries_for_date(Date.t()) :: MapSet.t()
  def missing_countries_for_date(date) do
    date
    |> Extract.global_data()
    |> Transform.daily_data_to_map()
    |> Enum.map(&Map.get(&1, :country_or_region))
    |> MapSet.new()
    |> MapSet.difference(Extract.country_names() |> MapSet.new())
  end

  @doc """
  Find countries that are present on dataset but spelling does not match with
  country name in `Countries` module for all dates
  """
  @spec all_missing_countries() :: MapSet.t()
  def all_missing_countries do
    Extract.global_dates()
    |> Enum.flat_map(fn date ->
      date
      |> Extract.global_data()
      |> Transform.daily_data_to_map()
      |> Enum.map(&Map.get(&1, :country_or_region))
    end)
    |> Enum.into(%MapSet{})
    |> MapSet.difference(MapSet.new(Extract.country_names()))
  end
end
