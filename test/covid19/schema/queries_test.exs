defmodule Covid19.Schema.QueriesTest do
  @moduledoc false

  use Covid19.DataCase

  alias Covid19.Schema.Queries

  import Covid19.Factory

  describe "test dates loaded and not loaded functions" do
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

    test "only returns empty list if all were loaded in global",
         %{dates: {dates, _}} do
      assert Queries.dates_not_loaded(
               dates |> Enum.to_list(),
               :global
             ) == MapSet.new()
    end

    test "only returns dates that were not loaded in the DB in global" do
      assert Queries.dates_not_loaded(
               [~D[2020-01-02], ~D[2020-02-02], ~D[2020-01-04], ~D[2021-10-10]],
               :global
             ) == MapSet.new([~D[2020-02-02], ~D[2021-10-10]])
    end

    test "returns empty list if all were loaded in us",
         %{dates: {_, dates}} do
      assert Queries.dates_not_loaded(
               dates |> Enum.to_list(),
               :us
             ) == MapSet.new()
    end

    test "only returns dates that were not loaded in the DB in us" do
      assert Queries.dates_not_loaded(
               [~D[2021-01-02], ~D[2021-02-02], ~D[2021-01-04], ~D[2020-10-10]],
               :us
             ) == MapSet.new([~D[2021-02-02], ~D[2020-10-10]])
    end
  end
end
