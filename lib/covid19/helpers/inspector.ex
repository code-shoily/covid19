defmodule Covid19.Helpers.Inspector do
  @moduledoc """
  Inspects CSV data to find any discrepancy that gets added to
  the sanitizer
  """
  alias Covid19.DataSource.DailyCSV
  alias Covid19.Helpers.Sanitizer

  @doc """
  Get a list of headers.
  """
  def headers do
    DailyCSV.read_all(false)
    |> Enum.flat_map(&hd/1)
    |> Enum.uniq()
  end

  @doc """
  Valid country names
  """
  def all_countries do
    Countries.all()
    |> Enum.map(& &1.name)
    |> Enum.sort()
  end

  @doc """
  Country names that have typos in the dataset.

  Ideally, this list should be zero, any typos found here should
  be properly translated in the `Sanitizer` module as soon as encountered.

  For example, if `incorrect_country_names` include `"USA"`, then it means
  we have not sanitized for `"USA"`, therefore, we must head over to `Sanitizer`
  and add `sanitized_country("USA"), do: "United States of America"`. This will
  not be an element of the output thereafter.
  """
  def incorrect_country_names do
    get_mentioned_countries()
    |> Enum.reject(fn country ->
      country in all_countries()
    end)
  end

  @doc """
  Countries that are not once mentioned in the dataset
  """
  def absent_countries do
    mentioned_countries = get_mentioned_countries()

    all_countries()
    |> Enum.reject(fn country ->
      country in mentioned_countries
    end)
  end

  def get_mentioned_countries do
    DailyCSV.read_all(true)
    |> Stream.flat_map(& &1)
    |> Stream.map(& &1.country_or_region)
    |> Stream.uniq()
    |> Stream.map(&Sanitizer.sanitize_country/1)
    |> Enum.sort()
  end

  def get_mentioned_zones do
    DailyCSV.read_all(true)
    |> Stream.flat_map(& &1)
    |> Stream.map(& &1.province_or_state)
    |> Stream.uniq()
    |> Enum.sort()
  end
end
