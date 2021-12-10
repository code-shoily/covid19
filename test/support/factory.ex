defmodule Covid19.Factory do
  use ExMachina.Ecto, repo: Covid19.Repo

  def daily_data_factory(attrs) do
    country_or_region = Enum.random(1..5 |> Enum.map(&"country-#{&1}"))
    province_or_state = Enum.random(["", "state-1", "province-1", "province-2"])
    county = Enum.random(["", "county-1", "county-2"])
    date = Map.get(attrs, :date, ~D[2020-01-01])

    %Covid19.Schema.DailyData{
      country_or_region: sequence(:country_or_region, fn _ -> country_or_region end),
      county: sequence(:county, fn _ -> county end),
      date: date,
      inserted_at: NaiveDateTime.utc_now(),
      province_or_state: sequence(:province_or_state, fn _ -> province_or_state end),
      src: "data/covid19/csse_covid_19_data/csse_covid_19_daily_reports/#{date}.csv",
      timestamp: NaiveDateTime.utc_now(),
      updated_at: NaiveDateTime.utc_now()
    }
    |> ExMachina.merge_attributes(attrs)
    |> ExMachina.evaluate_lazy_attributes()
  end

  def daily_data_us_factory(attrs) do
    province_or_state = Enum.random(["", "state-1", "province-1", "province-2"])
    date = Map.get(attrs, :date, ~D[2020-01-01])

    %Covid19.Schema.DailyDataUS{
      country_or_region: "United States of America",
      date: date,
      inserted_at: NaiveDateTime.utc_now(),
      province_or_state: sequence(:province_or_state, fn _ -> province_or_state end),
      src: "data/covid19/csse_covid_19_data/csse_covid_19_daily_reports_us/#{date}.csv",
      timestamp: NaiveDateTime.utc_now(),
      updated_at: NaiveDateTime.utc_now()
    }
    |> ExMachina.merge_attributes(attrs)
    |> ExMachina.evaluate_lazy_attributes()
  end
end
