defmodule Covid19Web.CaseChartComponent do
  @moduledoc false

  use Covid19Web, :live_component

  def mount(socket) do
    {:ok,
     socket
     |> assign(is_log: false)}
  end

  def handle_event("toggle-log-chart", _, socket) do
    {:noreply, socket |> update(:is_log, &Kernel.not/1)}
  end

  defp fmt(%Date{} = date) do
    Timex.format!(date, "%b %d, %Y", :strftime)
  end
end
