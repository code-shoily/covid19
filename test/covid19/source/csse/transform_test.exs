defmodule Covid19.Source.CSSE.TransformTest do
  @moduledoc false

  use ExUnit.Case

  alias Covid19.Source.CSSE.{Extract, Transform}

  @headers ~w/
    active
    case_fatality_ratio
    cases_28_days
    combined_key
    confirmed
    country_or_region
    country_or_region
    county
    date
    deaths
    deaths_28_days
    fips
    hospitalization_rate
    incidence_rate
    iso3
    latitude
    latitude
    longitude
    longitude
    mortality_rate
    people_hospitalized
    people_tested
    province_or_state
    province_or_state
    province_or_state
    recovered
    src
    testing_rate
    timestamp
    timestamp
    total_test_results
    uid
  /a

  @us_headers ~w/
    people_tested
    people_hospitalized
    mortality_rate
    uid
    iso3
    testing_rate
    hospitalization_rate
    total_test_results
    cases_28_days
    deaths_28_days
  /a

  @decimal_keys ~w/
    case_fatality_ratio
    fips
    hospitalization_rate
    incidence_rate
    latitude
    longitude
    testing_rate
    total_rest_results
  /a

  @integer_keys ~w/
    active
    confirmed
    deaths
    people_hospitalized
    people_tested
    recovered
    total_test_results
  /a

  describe "transforming global data extractions" do
    setup do
      extracted = Extract.global_data(~D[2021-01-01])
      transformed = Transform.daily_data_to_map(extracted)

      {:ok, %{extracted: extracted, transformed: transformed}}
    end

    test "nil value transforms to nil" do
      assert is_nil(Transform.daily_data_to_map(nil))
    end

    test "correct number of entries are transformed",
         %{extracted: extracted, transformed: transformed} do
      assert Enum.count(transformed) == Enum.count(extracted) - 1
    end

    test "correct headers are transformed", %{transformed: transformed} do
      assert MapSet.subset?(
               transformed |> Enum.flat_map(&Map.keys/1) |> MapSet.new(),
               MapSet.new(@headers)
             )
    end

    test "us headers are not available", %{transformed: transformed} do
      assert transformed
             |> Enum.flat_map(&Map.take(&1, @us_headers))
             |> Keyword.values()
             |> Enum.empty?()
    end

    test "all numeric data are cast", %{transformed: transformed} do
      assert transformed
             |> Enum.flat_map(&Map.take(&1, @integer_keys))
             |> Keyword.values()
             |> Enum.reject(fn v -> is_integer(v) || is_nil(v) end)
             |> Enum.empty?()
    end

    test "all decimal data are cast", %{transformed: transformed} do
      assert transformed
             |> Enum.flat_map(&Map.take(&1, @decimal_keys))
             |> Keyword.values()
             |> Enum.reject(fn v -> match?(%Decimal{}, v) || is_nil(v) end)
             |> Enum.empty?()
    end

    test "timestamps are in naive datetime", %{transformed: transformed} do
      assert transformed
             |> Enum.map(&Map.get(&1, :timestamp))
             |> Enum.reject(&match?(%NaiveDateTime{}, &1))
             |> Enum.empty?()
    end
  end

  describe "transforming us data extractions" do
    setup do
      extracted = Extract.us_data(~D[2021-01-01])
      transformed = Transform.daily_data_to_map(extracted)

      {:ok, %{extracted: extracted, transformed: transformed}}
    end

    test "correct number of entries are transformed",
         %{extracted: extracted, transformed: transformed} do
      assert Enum.count(transformed) == Enum.count(extracted) - 1
    end

    test "correct headers are transformed", %{transformed: transformed} do
      assert MapSet.subset?(
               transformed |> Enum.flat_map(&Map.keys/1) |> MapSet.new(),
               MapSet.new(@headers)
             )
    end

    test "all numeric data are cast", %{transformed: transformed} do
      assert transformed
             |> Enum.flat_map(&Map.take(&1, @integer_keys))
             |> Keyword.values()
             |> Enum.reject(fn v -> is_integer(v) || is_nil(v) end)
             |> Enum.empty?()
    end

    test "us headers are available", %{transformed: transformed} do
      assert transformed
             |> Enum.flat_map(&Map.take(&1, @us_headers))
             |> Keyword.values()
             |> Enum.any?()
    end

    test "all decimal data are cast", %{transformed: transformed} do
      assert transformed
             |> Enum.flat_map(&Map.take(&1, @decimal_keys))
             |> Keyword.values()
             |> Enum.reject(fn v -> match?(%Decimal{}, v) || is_nil(v) end)
             |> Enum.empty?()
    end

    test "timestamps are in naive datetime", %{transformed: transformed} do
      assert transformed
             |> Enum.map(&Map.get(&1, :timestamp))
             |> Enum.reject(&match?(%NaiveDateTime{}, &1))
             |> Enum.empty?()
    end
  end
end
