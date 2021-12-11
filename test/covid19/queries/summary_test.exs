defmodule Covid19.Queries.SummaryTest do
  @moduledoc false

  use Covid19.DataCase

  alias Covid19.Queries.Summary, as: Queries
  alias Covid19.Repo
  alias Covid19.Schema.{DailyData, DailyDataUS}

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
      assert Queries.dates_loaded(:global) == MapSet.new(dates)
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
      assert dates |> length() |> Queries.latest(:global) |> Enum.map(& &1.date) ==
               Enum.reverse(dates)
    end

    test "date ranging going beyond start date will return all for global",
         %{dates: {dates, _}} do
      assert Queries.latest(1000, :global) |> Enum.map(& &1.date) ==
               Enum.reverse(dates)
    end

    test "get last three dates global" do
      assert Queries.latest(3, :global) |> Enum.map(& &1.date) == [
               ~D[2020-01-15],
               ~D[2020-01-14],
               ~D[2020-01-13]
             ]
    end

    test "empty dataset will return empty list for global" do
      Repo.delete_all(DailyData)
      assert Queries.latest(1, :global) |> Enum.map(& &1.date) == []
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
      assert Queries.dates(:global) == Enum.reverse(dates)
    end

    test "global - empty dataset will return empty list" do
      Repo.delete_all(DailyData)
      assert Queries.dates(:global) == []
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
end
