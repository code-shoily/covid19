defmodule Covid19Web.WorldSummaryComponent do
  use Phoenix.LiveComponent

  defp fmt(number) when is_number(number) do
    Number.Delimit.number_to_delimited(number, precision: 0)
  end

  defp fmt(%Date{} = date) do
    Timex.format!(date, "%B %d, %Y", :strftime)
  end

  defp fmt(number, :signed) when is_number(number) do
    sign = (number > 0 && "+") || ""
    number = Number.Delimit.number_to_delimited(number, precision: 0)

    sign <> " " <> number
  end

  defp fmt(nil, _), do: "0"
end
