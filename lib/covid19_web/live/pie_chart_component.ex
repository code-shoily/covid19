defmodule Covid19Web.PieChartComponent do
  @moduledoc false

  use Covid19Web, :live_component

  defp fmt(%Date{} = date) do
    Timex.format!(date, "%b %d, %Y", :strftime)
  end
end
