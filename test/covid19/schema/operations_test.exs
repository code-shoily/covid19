defmodule Covid19.Schema.OperationsTest do
  @moduledoc false
  use Covid19.DataCase

  alias Covid19.Schema.{DailyData, DailyDataUS}
  alias Covid19.Schema.Operations

  import Covid19.Factory

  doctest Covid19.Schema.Operations

  describe "Operations.delete_daily_data/2 for global" do
    setup do
      dates = Date.range(~D[2020-01-01], ~D[2020-01-15])
      for date <- dates, do: insert(:daily_data, date: date)

      {:ok, %{dates: Enum.to_list(dates)}}
    end

    test "deletes all data that fall under within the dates given",
         %{dates: dates} do
      assert Repo.aggregate(DailyData, :count) == 15
      assert Operations.delete_daily_data(dates, :global) == {15, nil}
      assert Repo.aggregate(DailyData, :count) == 0
    end

    test "deletes nothing if no dates from the list were actually added" do
      dates = Enum.to_list(Date.range(~D[2021-01-01], ~D[2021-01-15]))
      data = Repo.all(DailyData)

      assert Operations.delete_daily_data(dates, :global) == {0, nil}
      assert Repo.all(DailyData) == data
    end

    test "deletes only the data that are inserted" do
      dates = [~D[2020-01-02], ~D[2020-01-05], ~D[2020-10-02]]
      assert Operations.delete_daily_data(dates, :global) == {2, nil}
      assert Repo.aggregate(DailyData, :count) == 13
      assert DailyData |> where([row], row.date in ^dates) |> Repo.all() == []
    end
  end

  describe "Operations.delete_daily_data/2 for us" do
    setup do
      dates = Date.range(~D[2020-01-01], ~D[2020-01-15])
      for date <- dates, do: insert(:daily_data_us, date: date)

      {:ok, %{dates: Enum.to_list(dates)}}
    end

    test "deletes all data that fall under within the dates given",
         %{dates: dates} do
      assert Repo.aggregate(DailyDataUS, :count) == 15
      assert Operations.delete_daily_data(dates, :us) == {15, nil}
      assert Repo.aggregate(DailyDataUS, :count) == 0
    end

    test "deletes nothing if no dates from the list were actually added" do
      dates = Enum.to_list(Date.range(~D[2021-01-01], ~D[2021-01-15]))
      data = Repo.all(DailyDataUS)

      assert Operations.delete_daily_data(dates, :us) == {0, nil}
      assert Repo.all(DailyDataUS) == data
    end

    test "deletes only the data that are inserted" do
      dates = [~D[2020-01-02], ~D[2020-01-05], ~D[2020-10-02]]
      assert Operations.delete_daily_data(dates, :us) == {2, nil}
      assert Repo.aggregate(DailyDataUS, :count) == 13
      assert DailyDataUS |> where([row], row.date in ^dates) |> Repo.all() == []
    end
  end
end
