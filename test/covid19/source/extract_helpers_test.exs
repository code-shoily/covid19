defmodule Covid19.Source.ExtractTest do
  use ExUnit.Case

  alias Covid19.Source.Extract, as: Extract

  doctest Extract

  @global_directory "test/fixtures/daily_data/global"
  @us_directory "test/fixtures/daily_data/us"

  describe "Testing the directory" do
    test "Test global directory shows the correct directory path" do
      assert Extract.global_directory() == @global_directory
    end

    test "Test US directory shows the correct directory path" do
      assert Extract.us_directory() == @us_directory
    end
  end

  describe "File resources are correct" do
    test "Test global resources are returned" do
      expected_resources = %{
        ~D[2021-01-01] => "test/fixtures/daily_data/global/01-01-2021.csv",
        ~D[2021-01-02] => "test/fixtures/daily_data/global/01-02-2021.csv",
        ~D[2021-01-03] => "test/fixtures/daily_data/global/01-03-2021.csv",
        ~D[2021-01-04] => "test/fixtures/daily_data/global/01-04-2021.csv"
      }

      assert Extract.global_resources() == expected_resources
    end

    test "US resources are returned" do
      expected_resources = %{
        ~D[2021-01-01] => "test/fixtures/daily_data/us/01-01-2021.csv",
        ~D[2021-01-02] => "test/fixtures/daily_data/us/01-02-2021.csv",
        ~D[2021-01-03] => "test/fixtures/daily_data/us/01-03-2021.csv",
        ~D[2021-01-04] => "test/fixtures/daily_data/us/01-04-2021.csv"
      }

      assert Extract.us_resources() == expected_resources
    end

    test "Returns global dates correctly" do
      expected_dates = [
        ~D[2021-01-01],
        ~D[2021-01-02],
        ~D[2021-01-03],
        ~D[2021-01-04]
      ]

      assert Extract.global_dates() == expected_dates
    end
  end
end
