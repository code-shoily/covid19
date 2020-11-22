defmodule Covid19.Helpers.ConvertersTest do
  use ExUnit.Case
  @moduletag :converters

  alias Covid19.Helpers.Converters

  describe "to_integer/1" do
    test "success: any alphanumeric string returns integer" do
      assert Converters.to_integer("10") == 10
      assert Converters.to_integer("10.0") == 10
      assert Converters.to_integer("10.7") == 10
      assert Converters.to_integer("10.1") == 10
    end

    test "success: any alphanumeric string with space padded returns the integer" do
      assert Converters.to_integer("42    ") == 42
    end

    test "success: alphanumeric string with space padded returns integer prefix" do
      assert Converters.to_integer("42    ") == 42
    end

    test "success: alphanumeric string with non-numeric suffix padded returns integer prefix" do
      assert Converters.to_integer("1 2 3 ...") == 1
    end

    test "failure: nil conversion is nil" do
      assert is_nil(Converters.to_integer(nil))
    end

    test "failure: empty string is nil" do
      assert is_nil(Converters.to_integer(""))
    end

    test "failure: non alphanumeric string is nil" do
      assert is_nil(Converters.to_integer("The 1"))
    end

    test "failure: any invalid number throws exception" do
      assert_raise FunctionClauseError, fn -> Converters.to_integer(10) end
      assert_raise FunctionClauseError, fn -> Converters.to_integer(10.0) end
    end
  end

  @decimal %Decimal{sign: 1, coef: 123, exp: -2}
  describe "to_decimal/1" do
    test "success: alphanumeric string returns decimal" do
      assert Converters.to_decimal("1.23") == @decimal
    end

    test "success: scientific notation string returns decimal" do
      assert Converters.to_decimal("1.23e0") == @decimal
    end

    test "failure: empty string is nil" do
      assert is_nil(Converters.to_decimal(""))
    end

    test "failure: non-alphanumeric string is nil" do
      assert is_nil(Converters.to_decimal("Nope"))
    end

    test "failure: nil raises exception" do
      assert_raise FunctionClauseError, fn -> Converters.to_decimal(nil) end
    end

    test "failure: non-binary raises exception" do
      assert_raise FunctionClauseError, fn -> Converters.to_decimal(10) end
    end
  end

  describe "to_datetime!/1" do
    test "success: converts ISO datetime to naive" do
      assert Converters.to_datetime!("2020-11-22T00:00") == ~N[2020-11-22 00:00:00]
      assert Converters.to_datetime!("2020-11-22 00:00") == ~N[2020-11-22 00:00:00]
      assert Converters.to_datetime!("2020-11-22T00:00:10") == ~N[2020-11-22 00:00:10]
    end

    test "success: converts ISO datetime to utime" do
      assert Converters.to_datetime!("2020-11-22T00:00Z") == ~U[2020-11-22 00:00:00Z]
      assert Converters.to_datetime!("2020-11-22 00:00Z") == ~U[2020-11-22 00:00:00Z]
      assert Converters.to_datetime!("2020-11-22T00:00:10Z") == ~U[2020-11-22 00:00:10Z]
    end

    test "success: converts  datetime to utime" do
      assert Converters.to_datetime!("2020-11-22T00:00Z") == ~U[2020-11-22 00:00:00Z]
      assert Converters.to_datetime!("2020-11-22 00:00Z") == ~U[2020-11-22 00:00:00Z]
      assert Converters.to_datetime!("2020-11-22T00:00:10Z") == ~U[2020-11-22 00:00:10Z]
    end

    test "success: converts \"%m/%d/%y %R\" datetime to naive" do
      assert Converters.to_datetime!("11/22/2020 12:00") == ~N[2020-11-22 12:00:00]
      assert Converters.to_datetime!("11/22/2020 22:00") == ~N[2020-11-22 22:00:00]
    end

    test "success: converts \"%m/%d/%y %R\" datetime can skip leading 0s" do
      assert Converters.to_datetime!("1/4/2020 2:10") == ~N[2020-01-04 02:10:00]
    end

    test "failure: only date without time raises exception" do
      assert_raise RuntimeError, fn -> Converters.to_datetime!("1/4/2020") end
      assert_raise RuntimeError, fn -> Converters.to_datetime!("2020-02-10") end
    end
  end
end
