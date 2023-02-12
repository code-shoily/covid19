defmodule Covid19.Queries.QueriesTest do
  @moduledoc false

  use Covid19.DataCase

  alias Covid19.Queries
  alias Covid19.Repo
  alias Covid19.Schema.{DailyData, DailyDataUS}
  alias Covid19.Source.Load

  import Covid19.Factory

  describe "Queries.dates_loaded/1" do
    setup do
      date_range_1 = Date.range(~D[2020-01-01], ~D[2020-01-15])
      for date <- date_range_1, do: insert(:daily_data, date: date)

      date_range_2 = Date.range(~D[2021-01-01], ~D[2021-01-15])
      for date <- date_range_2, do: insert(:daily_data_us, date: date)

      {:ok, %{dates: {date_range_1, date_range_2}}}
    end

    test "all inclusive dates will return to true for global",
         %{dates: {dates, _}} do
      assert Queries.dates_loaded(:world) == MapSet.new(dates)
    end

    test "all inclusive dates will return to true for us",
         %{dates: {_, dates}} do
      assert Queries.dates_loaded(:us) == MapSet.new(dates)
    end
  end

  describe "Queries.latest/1" do
    setup do
      date_range_1 = Date.range(~D[2020-01-01], ~D[2020-01-15])
      for date <- date_range_1, do: insert(:daily_data, date: date)

      date_range_2 = Date.range(~D[2021-01-01], ~D[2021-01-15])
      for date <- date_range_2, do: insert(:daily_data_us, date: date)

      {:ok, %{dates: {Enum.to_list(date_range_1), Enum.to_list(date_range_2)}}}
    end

    test "all inclusive dates will be returned in reverse order for global",
         %{dates: {dates, _}} do
      assert dates |> length() |> Queries.latest(:world) |> Enum.map(& &1.date) ==
               Enum.reverse(dates)
    end

    test "date ranging going beyond start date will return all for global",
         %{dates: {dates, _}} do
      assert Queries.latest(1000, :world) |> Enum.map(& &1.date) ==
               Enum.reverse(dates)
    end

    test "get last three dates global" do
      assert Queries.latest(3, :world) |> Enum.map(& &1.date) == [
               ~D[2020-01-15],
               ~D[2020-01-14],
               ~D[2020-01-13]
             ]
    end

    test "empty dataset will return empty list for global" do
      Repo.delete_all(DailyData)
      assert Queries.latest(1, :world) |> Enum.map(& &1.date) == []
    end

    test "all inclusive dates will be returned in reverse order for us",
         %{dates: {_, dates}} do
      assert dates |> length() |> Queries.latest(:us) |> Enum.map(& &1.date) ==
               Enum.reverse(dates)
    end

    test "date ranging going beyond start date will return all for us",
         %{dates: {_, dates}} do
      assert Queries.latest(1000, :us) |> Enum.map(& &1.date) ==
               Enum.reverse(dates)
    end

    test "get last three dates us" do
      assert Queries.latest(3, :us) |> Enum.map(& &1.date) == [
               ~D[2021-01-15],
               ~D[2021-01-14],
               ~D[2021-01-13]
             ]
    end

    test "empty dataset will return empty list for us" do
      Repo.delete_all(DailyDataUS)
      assert Queries.latest(1, :us) |> Enum.map(& &1.date) == []
    end
  end

  describe "Queries.dates/1" do
    setup do
      date_range_1 = Date.range(~D[2020-01-01], ~D[2020-01-15])
      for date <- date_range_1, do: insert(:daily_data, date: date)

      date_range_2 = Date.range(~D[2021-01-01], ~D[2021-01-15])
      for date <- date_range_2, do: insert(:daily_data_us, date: date)

      {:ok, %{dates: {Enum.to_list(date_range_1), Enum.to_list(date_range_2)}}}
    end

    test "gobal - all inclusive dates will be returned in reverse order",
         %{dates: {dates, _}} do
      assert Queries.dates(:world) == Enum.reverse(dates)
    end

    test "global - empty dataset will return empty list" do
      Repo.delete_all(DailyData)
      assert Queries.dates(:world) == []
    end

    test "us - all inclusive dates will be returned in reverse order",
         %{dates: {_, dates}} do
      assert Queries.dates(:us) == Enum.reverse(dates)
    end

    test "us - empty dataset will return empty list" do
      Repo.delete_all(DailyDataUS)
      assert Queries.dates(:us) == []
    end
  end

  describe "Queries.summary_by_dates/0" do
    setup do
      transformed_data = [
        build(:transformed_data, %{
          confirmed: 100,
          date: ~D[2020-01-01],
          deaths: 0,
          src: "S1",
          timestamp: ~N[2020-10-11 04:23:46]
        }),
        build(:transformed_data, %{
          confirmed: 130,
          country_or_region: "B",
          date: ~D[2020-01-01],
          deaths: 10,
          province_or_state: "S-1",
          src: "S1",
          timestamp: ~N[2020-10-11 04:23:46]
        }),
        build(:transformed_data, %{
          confirmed: 200,
          country_or_region: "C",
          date: ~D[2020-01-02],
          deaths: 11,
          province_or_state: "S-2",
          src: "S2",
          timestamp: ~N[2020-10-11 04:23:46]
        }),
        build(:transformed_data, %{
          confirmed: 400,
          date: ~D[2020-01-02],
          deaths: 23,
          src: "S2",
          timestamp: ~N[2020-10-11 04:23:46]
        }),
        build(:transformed_data, %{
          confirmed: 600,
          date: ~D[2020-01-03],
          deaths: 34,
          src: "S3",
          timestamp: ~N[2020-10-11 04:23:46]
        }),
        build(:transformed_data, %{
          confirmed: 650,
          date: ~D[2020-01-04],
          deaths: 55,
          src: "S4",
          timestamp: ~N[2020-10-11 04:23:46]
        }),
        build(:transformed_data, %{
          confirmed: 700,
          date: ~D[2020-01-05],
          deaths: 55,
          src: "S5",
          timestamp: ~N[2020-10-11 04:23:46]
        }),
        build(:transformed_data, %{
          confirmed: 700,
          date: ~D[2020-01-06],
          deaths: 70,
          src: "S6",
          timestamp: ~N[2020-10-11 04:23:46]
        })
      ]

      {:ok, %{transformed_data: transformed_data}}
    end

    test "empty data yields empty list" do
      assert Queries.summary_by_dates() == []
    end

    test "summarized data is presented correctly", %{transformed_data: data} do
      Load.insert(data, :world)

      expected_summary = [
        %{
          confirmed: 230,
          country_or_region: 2,
          date: ~D[2020-01-01],
          deaths: 10,
          last_updated: ~N[2020-10-11 04:23:46],
          new_confirmed: nil,
          new_deaths: nil,
          province_or_state: 2,
          src: "S1"
        },
        %{
          confirmed: 600,
          country_or_region: 2,
          date: ~D[2020-01-02],
          deaths: 34,
          last_updated: ~N[2020-10-11 04:23:46],
          new_confirmed: 370,
          new_deaths: 24,
          province_or_state: 2,
          src: "S2"
        },
        %{
          confirmed: 600,
          country_or_region: 1,
          date: ~D[2020-01-03],
          deaths: 34,
          last_updated: ~N[2020-10-11 04:23:46],
          new_confirmed: 0,
          new_deaths: 0,
          province_or_state: 1,
          src: "S3"
        },
        %{
          confirmed: 650,
          country_or_region: 1,
          date: ~D[2020-01-04],
          deaths: 55,
          last_updated: ~N[2020-10-11 04:23:46],
          new_confirmed: 50,
          new_deaths: 21,
          province_or_state: 1,
          src: "S4"
        },
        %{
          confirmed: 700,
          country_or_region: 1,
          date: ~D[2020-01-05],
          deaths: 55,
          last_updated: ~N[2020-10-11 04:23:46],
          new_confirmed: 50,
          new_deaths: 0,
          province_or_state: 1,
          src: "S5"
        },
        %{
          confirmed: 700,
          country_or_region: 1,
          date: ~D[2020-01-06],
          deaths: 70,
          last_updated: ~N[2020-10-11 04:23:46],
          new_confirmed: 0,
          new_deaths: 15,
          province_or_state: 1,
          src: "S6"
        }
      ]

      assert Queries.summary_by_dates() == expected_summary
    end
  end

  describe "Queries.locations_for_date/0" do
    setup do
      transformed_data = [
        build(:transformed_data, %{
          case_fatality_ratio: nil,
          confirmed: 100,
          country_or_region: "Country-0",
          date: ~D[2020-10-10],
          deaths: 0,
          incidence_rate: nil,
          latitude: Decimal.new(-150),
          longitude: Decimal.new(60)
        }),
        build(:transformed_data, %{
          case_fatality_ratio: 4,
          confirmed: 110,
          date: ~D[2020-10-10],
          deaths: 10,
          incidence_rate: 3,
          latitude: Decimal.new(90),
          longitude: Decimal.new(22)
        }),
        build(:transformed_data, %{
          case_fatality_ratio: 6,
          confirmed: 120,
          date: ~D[2020-10-10],
          deaths: 20,
          incidence_rate: 5,
          latitude: Decimal.new(0),
          longitude: Decimal.new(0)
        }),
        build(:transformed_data, %{
          case_fatality_ratio: 6,
          confirmed: 120,
          date: ~D[2021-10-10],
          deaths: 20,
          incidence_rate: 5,
          latitude: Decimal.new(0),
          longitude: Decimal.new(0)
        })
      ]

      {:ok, %{transformed_data: transformed_data}}
    end

    test "empty data yields empty list" do
      assert Queries.locations_for_date(~D[2020-10-10]) == []
    end

    test "summarized data is presented correctly", %{transformed_data: data} do
      Load.insert(data, :world)

      expected_summary = [
        %{
          case_fatality_ratio: nil,
          confirmed: 100,
          country_or_region: "Country-0",
          deaths: 0,
          incidence_rate: nil,
          latitude: Decimal.new(-150),
          longitude: Decimal.new(60)
        },
        %{
          case_fatality_ratio: Decimal.new(4),
          confirmed: 110,
          country_or_region: "Country-1",
          deaths: 10,
          incidence_rate: Decimal.new(3),
          latitude: Decimal.new(90),
          longitude: Decimal.new(22)
        },
        %{
          case_fatality_ratio: Decimal.new(6),
          confirmed: 120,
          country_or_region: "Country-1",
          deaths: 20,
          incidence_rate: Decimal.new(5),
          latitude: Decimal.new(0),
          longitude: Decimal.new(0)
        }
      ]

      assert Queries.locations_for_date(~D[2020-10-10]) == expected_summary
    end
  end

  describe "Queries.countries_or_regions_for_date/1" do
    setup do
      transformed_data = [
        build(:transformed_data, %{
          country_or_region: "A",
          confirmed: 50,
          date: ~D[2019-12-31],
          deaths: 10,
          src: "S1",
          timestamp: ~N[2020-10-11 04:23:46]
        }),
        build(:transformed_data, %{
          country_or_region: "C",
          confirmed: 100,
          date: ~D[2019-12-31],
          deaths: 0,
          src: "S1",
          timestamp: ~N[2020-10-11 04:23:46]
        }),
        build(:transformed_data, %{
          country_or_region: "A",
          confirmed: 100,
          date: ~D[2020-01-01],
          deaths: 15,
          src: "S1",
          timestamp: ~N[2020-10-11 04:23:46]
        }),
        build(:transformed_data, %{
          confirmed: 130,
          country_or_region: "B",
          date: ~D[2020-01-01],
          deaths: 10,
          province_or_state: "S-1",
          src: "S1",
          timestamp: ~N[2020-10-11 04:23:46]
        }),
        build(:transformed_data, %{
          confirmed: 200,
          country_or_region: "C",
          date: ~D[2020-10-01],
          deaths: 11,
          province_or_state: "S-2",
          src: "S2",
          timestamp: ~N[2020-10-11 04:23:46]
        }),
        build(:transformed_data, %{
          country_or_region: "A",
          confirmed: 400,
          date: ~D[2020-01-02],
          deaths: 23,
          src: "S2",
          timestamp: ~N[2020-10-11 04:23:46]
        }),
        build(:transformed_data, %{
          country_or_region: "C",
          confirmed: 500,
          date: ~D[2020-01-01],
          deaths: 30,
          src: "S3",
          timestamp: ~N[2020-10-11 04:23:46]
        }),
        build(:transformed_data, %{
          country_or_region: "C",
          confirmed: 100,
          date: ~D[2020-01-01],
          deaths: 4,
          src: "S3",
          province_or_state: "PS-1",
          timestamp: ~N[2020-10-11 04:23:46]
        })
      ]

      {:ok, %{transformed_data: transformed_data}}
    end

    test "empty data yields empty list" do
      assert Queries.countries_or_regions_for_date(~D[2020-01-01]) == []
    end

    test "summarized data is presented correctly", %{transformed_data: data} do
      Load.insert(data, :world)

      expected_summary = [
        %{
          confirmed: 100,
          country_or_region: "A",
          date: ~D[2020-01-01],
          deaths: 15,
          new_confirmed: 50,
          new_deaths: 5,
          province_or_state: 1
        },
        %{
          confirmed: 130,
          country_or_region: "B",
          date: ~D[2020-01-01],
          deaths: 10,
          new_confirmed: nil,
          new_deaths: nil,
          province_or_state: 1
        },
        %{
          confirmed: 600,
          country_or_region: "C",
          date: ~D[2020-01-01],
          deaths: 34,
          new_confirmed: 500,
          new_deaths: 34,
          province_or_state: 2
        }
      ]

      assert Queries.countries_or_regions_for_date(~D[2020-01-01]) == expected_summary
    end
  end

  describe "Queries.country_or_region_by_dates" do
    setup do
      transformed_data = [
        build(:transformed_data, %{
          country_or_region: "A",
          confirmed: 100,
          date: ~D[2020-01-01],
          deaths: 0,
          src: "S1",
          timestamp: ~N[2020-10-11 04:23:46]
        }),
        build(:transformed_data, %{
          confirmed: 130,
          country_or_region: "B",
          date: ~D[2020-01-01],
          deaths: 10,
          province_or_state: "S-1",
          src: "S1",
          timestamp: ~N[2020-10-11 04:23:46]
        }),
        build(:transformed_data, %{
          confirmed: 200,
          country_or_region: "C",
          date: ~D[2020-01-02],
          deaths: 11,
          province_or_state: "S-2",
          src: "S2",
          timestamp: ~N[2020-10-11 04:23:46]
        }),
        build(:transformed_data, %{
          country_or_region: "A",
          confirmed: 400,
          date: ~D[2020-01-02],
          deaths: 23,
          src: "S2",
          timestamp: ~N[2020-10-11 04:23:46]
        }),
        build(:transformed_data, %{
          country_or_region: "A",
          confirmed: 500,
          date: ~D[2020-01-03],
          deaths: 30,
          src: "S3",
          timestamp: ~N[2020-10-11 04:23:46]
        }),
        build(:transformed_data, %{
          country_or_region: "A",
          confirmed: 100,
          date: ~D[2020-01-03],
          deaths: 4,
          src: "S3",
          province_or_state: "PS-1",
          timestamp: ~N[2020-10-11 04:23:46]
        }),
        build(:transformed_data, %{
          country_or_region: "A",
          confirmed: 650,
          date: ~D[2020-01-04],
          deaths: 55,
          src: "S4",
          timestamp: ~N[2020-10-11 04:23:46]
        })
      ]

      {:ok, %{transformed_data: transformed_data}}
    end

    test "empty data yields empty list" do
      assert Queries.country_or_region_by_dates("NotACountry") == []
    end

    test "summarized data is presented correctly", %{transformed_data: data} do
      Load.insert(data, :world)

      expected_summary = [
        %{
          confirmed: 100,
          country_or_region: "A",
          date: ~D[2020-01-01],
          deaths: 0,
          new_confirmed: nil,
          new_deaths: nil,
          province_or_state: 1
        },
        %{
          confirmed: 400,
          country_or_region: "A",
          date: ~D[2020-01-02],
          deaths: 23,
          new_confirmed: 300,
          new_deaths: 23,
          province_or_state: 1
        },
        %{
          confirmed: 600,
          country_or_region: "A",
          date: ~D[2020-01-03],
          deaths: 34,
          new_confirmed: 200,
          new_deaths: 11,
          province_or_state: 2
        },
        %{
          confirmed: 650,
          country_or_region: "A",
          date: ~D[2020-01-04],
          deaths: 55,
          new_confirmed: 50,
          new_deaths: 21,
          province_or_state: 1
        }
      ]

      assert Queries.country_or_region_by_dates("A") == expected_summary
    end
  end

  describe "Queries.provinces_or_states_for_date/2" do
    setup do
      transformed_data = [
        build(:transformed_data, %{
          country_or_region: "A",
          confirmed: 50,
          date: ~D[2019-12-31],
          deaths: 10,
          src: "S1",
          timestamp: ~N[2020-10-11 04:23:46]
        }),
        build(:transformed_data, %{
          country_or_region: "C",
          confirmed: 100,
          date: ~D[2019-12-31],
          deaths: 0,
          src: "S1",
          timestamp: ~N[2020-10-11 04:23:46]
        }),
        build(:transformed_data, %{
          country_or_region: "A",
          confirmed: 100,
          date: ~D[2020-01-01],
          deaths: 15,
          src: "S1",
          timestamp: ~N[2020-10-11 04:23:46]
        }),
        build(:transformed_data, %{
          confirmed: 130,
          country_or_region: "B",
          date: ~D[2020-01-01],
          deaths: 10,
          province_or_state: nil,
          src: "S1",
          timestamp: ~N[2020-10-11 04:23:46]
        }),
        build(:transformed_data, %{
          confirmed: 200,
          country_or_region: "C",
          date: ~D[2020-10-01],
          deaths: 11,
          province_or_state: "S-2",
          src: "S2",
          timestamp: ~N[2020-10-11 04:23:46]
        }),
        build(:transformed_data, %{
          country_or_region: "A",
          confirmed: 400,
          date: ~D[2020-01-02],
          deaths: 23,
          src: "S2",
          timestamp: ~N[2020-10-11 04:23:46]
        }),
        build(:transformed_data, %{
          country_or_region: "C",
          confirmed: 500,
          date: ~D[2020-01-01],
          deaths: 30,
          src: "S3",
          timestamp: ~N[2020-10-11 04:23:46]
        }),
        build(:transformed_data, %{
          country_or_region: "C",
          confirmed: 500,
          date: ~D[2020-01-01],
          deaths: 30,
          province_or_state: "PS-0",
          src: "S3",
          timestamp: ~N[2020-10-11 04:23:46]
        }),
        build(:transformed_data, %{
          country_or_region: "C",
          confirmed: 100,
          date: ~D[2020-01-01],
          deaths: 4,
          province_or_state: "PS-1",
          src: "S3",
          timestamp: ~N[2020-10-11 04:23:46]
        })
      ]

      {:ok, %{transformed_data: transformed_data}}
    end

    test "empty data yields empty list" do
      assert Queries.provinces_or_states_for_date(
               "NotACountry",
               ~D[2020-01-01]
             ) == []
    end

    test "summarized data is presented correctly", %{transformed_data: data} do
      Load.insert(data, :world)

      expected_summary = [
        %{
          confirmed: 500,
          country_or_region: "C",
          date: ~D[2020-01-01],
          deaths: 30,
          new_confirmed: nil,
          new_deaths: nil,
          province_or_state: "PS-0"
        },
        %{
          confirmed: 100,
          country_or_region: "C",
          date: ~D[2020-01-01],
          deaths: 4,
          new_confirmed: nil,
          new_deaths: nil,
          province_or_state: "PS-1"
        },
        %{
          confirmed: 500,
          country_or_region: "C",
          date: ~D[2020-01-01],
          deaths: 30,
          new_confirmed: 400,
          new_deaths: 30,
          province_or_state: "Province/State-1"
        }
      ]

      assert Queries.provinces_or_states_for_date("C", ~D[2020-01-01]) == expected_summary
    end

    test "summarizes data without province correctly", %{transformed_data: data} do
      Load.insert(data, :world)

      expected_summary = [
        %{
          confirmed: 130,
          country_or_region: "B",
          date: ~D[2020-01-01],
          deaths: 10,
          new_confirmed: nil,
          new_deaths: nil,
          province_or_state: nil
        }
      ]

      assert Queries.provinces_or_states_for_date("B", ~D[2020-01-01]) == expected_summary
    end
  end
end
