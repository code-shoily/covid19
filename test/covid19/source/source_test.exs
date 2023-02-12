defmodule Covid19.SourceTest do
  @moduledoc false

  use Covid19.DataCase

  alias Covid19.Repo
  alias Covid19.Schema.{DailyData, DailyDataUS}
  alias Covid19.Source

  import Ecto.Query

  doctest Covid19.Source

  describe "Source.sync_all/0" do
    test "sync_all syncs all global data with the database" do
      assert Source.sync_all() == %{global: 15_938, us: 232}
    end

    test "sync_all global does not sync anything if dates are already loaded" do
      Source.sync_all(:world)
      assert Source.sync_all() == %{global: 0, us: 232}
    end

    test "global - syncs the last unloaded dates when called on partial db" do
      range = [~D[2021-01-01], ~D[2021-01-02], ~D[2021-01-03]]

      Source.sync(range, :world)
      Source.sync(range, :us)

      assert Repo.aggregate(DailyData, :count) == 11_953
      assert Repo.aggregate(DailyDataUS, :count) == 174

      Source.sync_all()

      assert Repo.aggregate(DailyData, :count) == 15_938
      assert Repo.aggregate(DailyDataUS, :count) == 232
    end
  end

  describe "Source.sync_all/1" do
    test "sync_all syncs all global data with the database" do
      assert Source.sync_all(:world) == 15_938
    end

    test "sync_all global does not sync anything if dates are already loaded" do
      Source.sync_all(:world)
      assert 0 == Source.sync_all(:world)
    end

    test "global - syncs the last unloaded dates when called on partial db" do
      Source.sync([~D[2021-01-01], ~D[2021-01-02], ~D[2021-01-03]], :world)
      assert Repo.aggregate(DailyData, :count) == 11_953
      Source.sync_all(:world)
      assert Repo.aggregate(DailyData, :count) == 15_938
    end

    test "sync_all syncs all us data with the database" do
      assert Source.sync_all(:us) == 232
    end

    test "sync_all us does not sync anything if dates are already loaded" do
      Source.sync_all(:us)
      assert Source.sync_all(:us) == 0
    end

    test "us - syncs the last unloaded dates when called on partial db" do
      Source.sync([~D[2021-01-01], ~D[2021-01-02], ~D[2021-01-03]], :us)
      assert Repo.aggregate(DailyDataUS, :count) == 174
      Source.sync_all(:us)
      assert Repo.aggregate(DailyDataUS, :count) == 232
    end
  end

  describe "Source.sync/2" do
    test "global - syncs the available dates" do
      assert Source.sync(
               [
                 ~D[2020-12-31],
                 ~D[2021-01-01],
                 ~D[2021-01-02],
                 ~D[2021-01-03]
               ],
               :world
             ) == 11_953

      assert Repo.aggregate(DailyData, :count) == 11_953
    end

    test "global - syncing for inexistent date does nothing" do
      assert Source.sync([~D[2022-01-01], ~D[2020-01-01]], :world) == 0
      assert Repo.aggregate(DailyData, :count) == 0
    end

    test "us - syncs available dates" do
      assert Source.sync(
               [
                 ~D[2020-12-31],
                 ~D[2021-01-01],
                 ~D[2021-01-02],
                 ~D[2021-01-03]
               ],
               :us
             ) == 174

      assert Repo.aggregate(DailyDataUS, :count) == 174
    end

    test "us - syncing for inexistent date does nothing" do
      assert Source.sync([~D[2022-01-01], ~D[2020-01-01]], :us) == 0
      assert Repo.aggregate(DailyDataUS, :count) == 0
    end
  end

  describe "Source.rollback/2" do
    setup do
      Source.sync_all(:world)
      Source.sync_all(:us)

      :ok
    end

    test "global - rollback rolls data back by n days" do
      assert Repo.aggregate(DailyData, :count) == 15_938

      assert DailyData
             |> distinct([:date])
             |> select([i], i.date)
             |> Repo.all()
             |> MapSet.new()
             |> MapSet.member?(~D[2021-01-04])

      Source.rollback(1, :world)

      assert Repo.aggregate(DailyData, :count) == 11_953

      refute DailyData
             |> distinct([:date])
             |> select([i], i.date)
             |> Repo.all()
             |> MapSet.new()
             |> MapSet.member?(~D[2021-01-04])
    end

    test "us - rollback rolls data back by n days" do
      assert Repo.aggregate(DailyDataUS, :count) == 232

      assert DailyDataUS
             |> distinct([:date])
             |> select([i], i.date)
             |> Repo.all()
             |> MapSet.new()
             |> MapSet.member?(~D[2021-01-04])

      Source.rollback(1, :us)

      assert Repo.aggregate(DailyDataUS, :count) == 174

      refute DailyDataUS
             |> distinct([:date])
             |> select([i], i.date)
             |> Repo.all()
             |> MapSet.new()
             |> MapSet.member?(~D[2021-01-04])
    end

    test "global - rollback for a range exceding added data will empty the db" do
      assert Repo.aggregate(DailyData, :count) == 15_938

      Source.rollback(100, :world)

      assert Repo.aggregate(DailyData, :count) == 0
    end

    test "us - rollback for a range exceding added data will empty the db" do
      assert Repo.aggregate(DailyDataUS, :count) == 232

      Source.rollback(100, :us)

      assert Repo.aggregate(DailyDataUS, :count) == 0
    end
  end
end
