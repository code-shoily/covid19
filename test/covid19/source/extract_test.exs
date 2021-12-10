defmodule Covid19.Source.ExtractTest do
  @moduledoc false

  use ExUnit.Case

  alias Covid19.Source.Extract

  doctest Extract

  @dates [~D[2021-01-01], ~D[2021-01-02], ~D[2021-01-03], ~D[2021-01-04]]
  @global_directory "test/fixtures/daily_data/global"
  @us_directory "test/fixtures/daily_data/us"

  describe "get directories of global and us" do
    test "global_directory/0" do
      assert Extract.global_directory() == @global_directory
    end

    test "us_directory/0" do
      assert Extract.us_directory() == @us_directory
    end
  end

  describe "get file names from us and globaal directories" do
    test "global_resources/0" do
      expected_resources = %{
        ~D[2021-01-01] => "test/fixtures/daily_data/global/01-01-2021.csv",
        ~D[2021-01-02] => "test/fixtures/daily_data/global/01-02-2021.csv",
        ~D[2021-01-03] => "test/fixtures/daily_data/global/01-03-2021.csv",
        ~D[2021-01-04] => "test/fixtures/daily_data/global/01-04-2021.csv"
      }

      assert Extract.global_resources() == expected_resources
    end

    test "us_resources" do
      expected_resources = %{
        ~D[2021-01-01] => "test/fixtures/daily_data/us/01-01-2021.csv",
        ~D[2021-01-02] => "test/fixtures/daily_data/us/01-02-2021.csv",
        ~D[2021-01-03] => "test/fixtures/daily_data/us/01-03-2021.csv",
        ~D[2021-01-04] => "test/fixtures/daily_data/us/01-04-2021.csv"
      }

      assert Extract.us_resources() == expected_resources
    end
  end

  describe "get the dates from the file resources" do
    test "global_dates/0" do
      assert Extract.global_dates() == @dates
    end

    test "us_dates/0" do
      assert Extract.us_dates() == @dates
    end
  end

  describe "global_data/1" do
    test "returns nil on unavailable date" do
      assert is_nil(Extract.global_data(~D[2018-10-10]))
    end

    test "gets the header correctly" do
      data = Extract.global_data(~D[2021-01-01])
      assert hd(data) == ~w/
        src
        date
        FIPS
        Admin2
        Province_State
        Country_Region
        Last_Update
        Lat
        Long_ Confirmed
        Deaths
        Recovered
        Active
        Combined_Key
        Incident_Rate
        Case_Fatality_Ratio/
    end

    for {date, row_count} <- %{
          ~D[2021-01-01] => 3985,
          ~D[2021-01-02] => 3985,
          ~D[2021-01-03] => 3986,
          ~D[2021-01-04] => 3986
        } do
      @tag params: {date, row_count}
      test "has the correct number of rows on #{date}",
           %{params: {date, row_count}} do
        assert length(Extract.global_data(date)) == row_count
      end
    end

    for date <- @dates do
      @tag params: date
      test "has the source correctly presented on #{date}", %{params: date} do
        [headers | rows] = Extract.global_data(date)
        assert hd(headers) == "src"

        assert rows |> Enum.map(&hd/1) |> Enum.uniq() == [
                 Extract.global_resources() |> Map.get(date)
               ]
      end
    end

    for date <- @dates do
      @tag params: date
      test "has the date correctly presented on #{date}", %{params: date} do
        [headers | rows] = Extract.global_data(date)
        assert hd(tl(headers)) == "date"

        assert rows |> Enum.map(fn [_, v | _] -> v end) |> Enum.uniq() == [date]
      end
    end
  end

  describe "us_data/1" do
    test "returns nil on unavailable date" do
      assert is_nil(Extract.us_data(~D[2018-10-10]))
    end

    test "gets the header correctly" do
      data = Extract.us_data(~D[2021-01-01])
      assert hd(data) == ~w/
        src
        date
        Province_State
        Country_Region
        Last_Update
        Lat
        Long_
        Confirmed
        Deaths
        Recovered
        Active
        FIPS
        Incident_Rate
        Total_Test_Results
        People_Hospitalized
        Case_Fatality_Ratio
        UID
        ISO3
        Testing_Rate
        Hospitalization_Rate
      /
    end

    for {date, row_count} <- %{
          ~D[2021-01-01] => 59,
          ~D[2021-01-02] => 59,
          ~D[2021-01-03] => 59,
          ~D[2021-01-04] => 59
        } do
      @tag params: {date, row_count}
      test "has the correct number of rows for #{date}",
           %{params: {date, row_count}} do
        assert length(Extract.us_data(date)) == row_count
      end
    end

    for date <- @dates do
      @tag params: date
      test "has the source correctly presented on #{date}", %{params: date} do
        [headers | rows] = Extract.us_data(date)
        assert hd(headers) == "src"

        assert rows |> Enum.map(&hd/1) |> Enum.uniq() == [
                 Extract.us_resources() |> Map.get(date)
               ]
      end
    end

    for date <- @dates do
      @tag params: date
      test "has the date correctly presented on #{date}", %{params: date} do
        [headers | rows] = Extract.us_data(date)
        assert hd(tl(headers)) == "date"

        assert rows |> Enum.map(fn [_, v | _] -> v end) |> Enum.uniq() == [date]
      end
    end
  end
end
