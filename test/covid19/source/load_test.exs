defmodule Covid19.Source.LoadTest do
  @moduledoc false

  use Covid19.DataCase

  alias Covid19.Source.Load

  describe "loading to the global table" do
    setup do
      single = [
        %{
          active: nil,
          case_fatality_ratio: Decimal.new("4.69374358712901"),
          combined_key: "Afghanistan",
          confirmed: 156_911,
          country_or_region: "Afghanistan",
          county: "",
          date: ~D[2021-11-22],
          deaths: 7303,
          fips: nil,
          incidence_rate: Decimal.new("403.076514357496"),
          latitude: Decimal.new("33.93911"),
          longitude: Decimal.new("67.709953"),
          province_or_state: "",
          recovered: nil,
          src: "data/covid19/csse_covid_19_data/csse_covid_19_daily_reports/11-22-2021.csv",
          timestamp: ~N[2021-11-23 04:22:39]
        }
      ]

      multiple = [
        %{
          confirmed: 0,
          country_or_region: "Malaysia",
          date: ~D[2020-01-22],
          deaths: 0,
          province_or_state: "W.P. Putrajaya",
          recovered: 0,
          src: "data/covid19/csse_covid_19_data/csse_covid_19_daily_reports/01-22-2020.csv",
          timestamp: ~N[2020-01-22 17:00:00]
        },
        %{
          confirmed: 0,
          country_or_region: "Malaysia",
          date: ~D[2020-01-22],
          deaths: 0,
          province_or_state: "Unknown",
          recovered: 0,
          src: "data/covid19/csse_covid_19_data/csse_covid_19_daily_reports/01-22-2020.csv",
          timestamp: ~N[2020-01-22 17:00:00]
        },
        %{
          confirmed: 0,
          country_or_region: "Tonga",
          date: ~D[2020-01-22],
          deaths: 0,
          province_or_state: "",
          recovered: 0,
          src: "data/covid19/csse_covid_19_data/csse_covid_19_daily_reports/01-22-2020.csv",
          timestamp: ~N[2020-01-22 17:00:00]
        }
      ]

      duplicate = single ++ single ++ single

      {:ok, %{single: single, multiple: multiple, duplicate: duplicate}}
    end

    test "returns 0 when nil is attempted" do
      assert {0, nil} = Load.insert(nil, :global)
    end

    test "loads single data into table", %{single: single} do
      assert {1, nil} = Load.insert(single, :global)
    end

    test "loads multiple data into table", %{multiple: multiple} do
      {data, nil} = Load.insert(multiple, :global)
      assert data == length(multiple)
    end

    test "deduplicates incoming data", %{duplicate: duplicate} do
      assert {1, nil} = Load.insert(duplicate, :global)
    end
  end

  describe "loading to the US table" do
    setup do
      single = [
        %{
          active: nil,
          case_fatality_ratio: Decimal.new("1.9062788720066512"),
          confirmed: 843_161,
          country_or_region: "United States of America",
          date: ~D[2021-11-22],
          deaths: 16_073,
          fips: Decimal.new("1.0"),
          hospitalization_rate: nil,
          incidence_rate: Decimal.new("17196.189823553465"),
          iso3: "USA",
          latitude: Decimal.new("32.3182"),
          longitude: Decimal.new("-86.9023"),
          people_hospitalized: nil,
          province_or_state: "Alabama",
          recovered: nil,
          src: "data/covid19/csse_covid_19_data/csse_covid_19_daily_reports_us/11-22-2021.csv",
          testing_rate: Decimal.new("127123.67573322238"),
          timestamp: ~N[2021-11-23 04:32:11],
          total_test_results: 6_233_109,
          uid: "84000001.0"
        }
      ]

      multiple = [
        %{
          active: 4597,
          confirmed: 4845,
          country_or_region: "United States of America",
          date: ~D[2020-04-22],
          deaths: 248,
          fips: Decimal.new("55"),
          hospitalization_rate: Decimal.new("26.873065015479877"),
          incidence_rate: Decimal.new("93.63095027587794"),
          iso3: "USA",
          latitude: Decimal.new("44.2685"),
          longitude: Decimal.new("-89.6165"),
          mortality_rate: Decimal.new("5.118679050567596"),
          people_hospitalized: 1302,
          people_tested: 54_347,
          province_or_state: "Wisconsin",
          recovered: nil,
          src: "data/covid19/csse_covid_19_data/csse_covid_19_daily_reports_us/04-22-2020.csv",
          testing_rate: Decimal.new("1050.2706407932174"),
          timestamp: ~N[2020-04-22 23:40:26],
          uid: "84000055"
        },
        %{
          active: 441,
          confirmed: 447,
          country_or_region: "United States of America",
          date: ~D[2020-04-22],
          deaths: 6,
          fips: Decimal.new("56"),
          hospitalization_rate: Decimal.new("11.6331096196868"),
          incidence_rate: Decimal.new("89.89622717400049"),
          iso3: "USA",
          latitude: Decimal.new("42.756"),
          longitude: Decimal.new("-107.3025"),
          mortality_rate: Decimal.new("1.342281879194631"),
          people_hospitalized: 52,
          people_tested: 7623,
          province_or_state: "Wyoming",
          recovered: 254,
          src: "data/covid19/csse_covid_19_data/csse_covid_19_daily_reports_us/04-22-2020.csv",
          testing_rate: Decimal.new("1533.062505027753"),
          timestamp: ~N[2020-04-22 23:40:26],
          uid: "84000056"
        },
        %{
          active: -77_366,
          confirmed: 0,
          country_or_region: "United States of America",
          date: ~D[2020-04-22],
          deaths: 0,
          fips: nil,
          hospitalization_rate: nil,
          incidence_rate: nil,
          iso3: "USA",
          latitude: nil,
          longitude: nil,
          mortality_rate: nil,
          people_hospitalized: nil,
          people_tested: nil,
          province_or_state: "Recovered",
          recovered: 77_366,
          src: "data/covid19/csse_covid_19_data/csse_covid_19_daily_reports_us/04-22-2020.csv",
          testing_rate: nil,
          timestamp: ~N[2020-04-22 23:40:26],
          uid: "84070001"
        }
      ]

      duplicate = single ++ single ++ single

      {:ok, %{single: single, multiple: multiple, duplicate: duplicate}}
    end

    test "returns 0 when nil is attempted" do
      assert {0, nil} = Load.insert(nil, :us)
    end

    test "loads single data into table", %{single: single} do
      assert {1, nil} = Load.insert(single, :us)
    end

    test "loads multiple data into table", %{multiple: multiple} do
      {data, nil} = Load.insert(multiple, :us)
      assert data == length(multiple)
    end

    test "deduplicates incoming data", %{duplicate: duplicate} do
      assert {1, nil} = Load.insert(duplicate, :us)
    end
  end
end
