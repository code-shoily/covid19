defmodule Covid19.Queries.SQL do
  @moduledoc """
  All raw SQL queries for getting data reports
  """
  def summary_by_dates do
    """
    WITH summary AS (
      SELECT
          date,
          count(distinct country_or_region) total_country_or_region,
          count(distinct province_or_state) total_province_or_state,
          sum(confirmed) total_confirmed,
          sum(deaths) total_deaths,
          max(src) src,
          max(timestamp) last_updated
      FROM
          daily_data
      GROUP BY date
    )
    SELECT
      date,
      src,
      last_updated,
      total_country_or_region,
      total_province_or_state,
      total_confirmed,
      (total_confirmed - lag(total_confirmed, 1) over (order by date)) new_confirmed,
      total_deaths,
      (total_deaths - lag(total_deaths, 1) over (order by date)) new_deaths
    FROM
      summary;
    """
  end

  def countries_or_regions_for_date do
    """
    WITH summary AS (
      SELECT
          date,
          country_or_region,
          count(distinct province_or_state) total_province_or_state,
          sum(confirmed) total_confirmed,
          sum(deaths) total_deaths,
          max(src) src,
          max(timestamp) last_updated
      FROM
          daily_data
      WHERE date BETWEEN $1 AND $2
      GROUP BY date, country_or_region
    ), secondary AS (
        SELECT date,
              src,
              last_updated,
              country_or_region,
              total_province_or_state,
              total_confirmed,
              (total_confirmed -
                lag(total_confirmed, 1) over (partition by country_or_region order by date))             new_confirmed,
              total_deaths,
              (total_deaths - lag(total_deaths, 1) over (partition by country_or_region order by date)) new_deaths
        FROM summary
    )
    SELECT * FROM secondary WHERE new_confirmed IS NOT NULL;
    """
  end

  def locations_for_date do
    """
    SELECT
        latitude, longitude, confirmed, deaths, case_fatality_ratio, incidence_rate
    FROM
        daily_data
    WHERE
        date = $1 AND latitude IS NOT NULL AND longitude IS NOT NULL;
    """
  end

  def country_or_region_by_dates do
    """
    WITH summary AS (
      SELECT
          date,
          country_or_region,
          count(distinct province_or_state) total_province_or_state,
          sum(confirmed) total_confirmed,
          sum(deaths) total_deaths,
          max(src) src,
          max(timestamp) last_updated
      FROM
          daily_data
      WHERE country_or_region = $1
      GROUP BY date, country_or_region
    )
    SELECT
        date,
        src,
        last_updated,
        country_or_region,
        total_province_or_state,
        total_confirmed,
        (total_confirmed - lag(total_confirmed, 1) over (order by date)) new_confirmed,
        total_deaths,
        (total_deaths - lag(total_deaths, 1) over (order by date)) new_deaths
    FROM
        summary;
    """
  end

  def provinces_or_states_for_date do
    """
    WITH summary AS (
      SELECT
          date,
          province_or_state,
          sum(confirmed) total_confirmed,
          sum(deaths) total_deaths,
          max(src) src,
          max(timestamp) last_updated
      FROM
          daily_data
      WHERE date BETWEEN $1 AND $2 AND country_or_region = $3
      GROUP BY date, province_or_state
    ), secondary AS (
        SELECT date,
              src,
              last_updated,
              province_or_state,
              total_confirmed,
              (total_confirmed -
                lag(total_confirmed, 1) over (partition by province_or_state order by date)) new_confirmed,
              total_deaths,
              (total_deaths - lag(total_deaths, 1) over (partition by province_or_state order by date)) new_deaths
        FROM summary
    )
    SELECT * FROM secondary WHERE new_confirmed IS NOT NULL;
    """
  end
end
