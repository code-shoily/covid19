defmodule Covid19.Collect.HelpersTest do
  use ExUnit.Case

  alias Covid19.Collect.Helpers

  @global_directory "test/fixtures/daily_data/global"
  @us_directory "test/fixtures/daily_data/us"

  describe "Testing the directory helpers" do
    test "Test global directory shows the correct directory path" do
      assert Helpers.global_directory() == @global_directory
    end

    test "Test US directory shows the correct directory path" do
      assert Helpers.us_directory() == @us_directory
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

      assert Helpers.global_resources() == expected_resources
    end

    test "US resources are returned" do
      expected_resources = %{
        ~D[2021-01-01] => "test/fixtures/daily_data/us/01-01-2021.csv",
        ~D[2021-01-02] => "test/fixtures/daily_data/us/01-02-2021.csv",
        ~D[2021-01-03] => "test/fixtures/daily_data/us/01-03-2021.csv",
        ~D[2021-01-04] => "test/fixtures/daily_data/us/01-04-2021.csv"
      }

      assert Helpers.us_resources() == expected_resources
    end
  end
end
