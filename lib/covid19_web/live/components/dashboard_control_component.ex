defmodule Covid19Web.DashboardControlComponent do
  @moduledoc false

  alias Covid19Web.CalendarComponent

  use Covid19Web, :live_component

  defp fmt(number) when is_number(number) do
    Number.Delimit.number_to_delimited(number, precision: 0)
  end

  defp fmt(%Date{} = date) do
    Timex.format!(date, "%B %d, %Y", :strftime)
  end
end
