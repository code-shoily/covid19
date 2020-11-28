defmodule Covid19Web.Views.Helpers do
  @moduledoc """
  View helpers for formatting, validating etc
  """

  def format_date(%Date{} = date) do
    Timex.format!(date, "%b %d, %Y", :strftime)
  end

  def format_number(number) when is_number(number) do
    Number.Delimit.number_to_delimited(number, precision: 0)
  end

  def format_number(_), do: "0"

  def format_signed_number(number) when is_number(number) do
    sign = (number > 0 && "+") || ""
    number = Number.Delimit.number_to_delimited(number, precision: 0)

    sign <> " " <> number
  end

  def format_signed_number(_), do: "0"
end
