defmodule Covid19.Helpers.Converters do
  @moduledoc """
  Module to facilitate all kinds of conversion.
  """

  @doc """
  Coerces numeric data as integers
  """
  def to_integer(number) when is_binary(number) do
    case Integer.parse(number) do
      {number, _} -> number
      :error -> nil
    end
  end

  def to_integer(nil), do: nil

  @doc """
  Coerces numeric data as decimal
  """
  def to_decimal(number) when is_binary(number) do
    case Decimal.parse(number) do
      {number, ""} -> number
      _ -> nil
    end
  end

  @doc """
  Converts str into `NaiveDateTime`, the file has two different formats of time,
  this one accommodates both.
  """
  def to_datetime!(str) do
    case to_datetime(str) do
      {:ok, date} -> date
      _ -> raise "Invalid date format"
    end
  end

  defp to_datetime(""), do: {:ok, nil}

  defp to_datetime(str) do
    case Timex.parse(str, "{ISO:Extended}") do
      {:ok, _} = date -> date
      {:error, _} -> Timex.parse(format_date(str), "%m/%d/%y %R", :strftime)
    end
  end

  defp format_date(date_str) do
    with [date, time] <- String.split(date_str, " "),
         [month, day, year] <- String.split(date, "/") do
      month = String.pad_leading(month, 2, "0")
      day = String.pad_leading(day, 2, "0")

      year =
        case String.split_at(year, 2) do
          {two_digit, ""} -> two_digit
          {_, four_digit} -> four_digit
        end

      "#{month}/#{day}/#{year} #{time}"
    end
  end
end
