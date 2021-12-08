defmodule Covid19.Source.Checkers do
  @moduledoc """
  This module contains functions that help with checking the sanity of the data.

  They are to be used in the REPL by the developer and not called by the app.
  """
  alias Covid19.Source
  alias Covid19.Source.Helpers

  @doc """
  Find countries that are present on dataset but spelling does not match with
  country name in `Countries` module for a particujlar date
  """
  @spec missing_countries_for_date(Date.t()) :: MapSet.t()
  def missing_countries_for_date(date) do
    date
    |> Source.daily_global_data()
    |> Enum.map(&Map.get(&1, "country_or_region"))
    |> MapSet.new()
    |> MapSet.difference(Helpers.country_names() |> MapSet.new())
  end

  @doc """
  Find countries that are present on dataset but spelling does not match with
  country name in `Countries` module for all dates
  """
  @spec all_missing_countries() :: MapSet.t()
  def all_missing_countries do
    Helpers.global_dates()
    |> Enum.reduce(MapSet.new(), fn date, acc ->
      IO.puts(date)

      date
      |> missing_countries_for_date()
      |> MapSet.union(acc)
    end)
  end
end
