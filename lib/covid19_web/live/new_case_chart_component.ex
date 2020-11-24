defmodule Covid19Web.NewCaseChartComponent do
  use Phoenix.LiveComponent

  defp fmt(%Date{} = date) do
    Timex.format!(date, "%b %d, %Y", :strftime)
  end
end
