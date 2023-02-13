defmodule Covid19Web.DashboardLive do
  use Covid19Web, :live_view

  import Covid19Web.SummaryComponents

  alias Covid19.Queries

  def mount(_, _, socket) do
    summary = Queries.summary_by_dates()

    assigns = %{
      summary: summary,
      dates: get_dates(summary),
      date_index: -1
    }

    {:ok, assign(socket, assigns)}
  end

  def handle_event("start", _, socket) do
    {:noreply, update(socket, :date_index, fn _ -> 0 end)}
  end

  def handle_event("end", _, socket) do
    {:noreply, update(socket, :date_index, fn _ -> -1 end)}
  end

  def handle_event("prev", _, socket) do
    date_size = Enum.count(socket.assigns.dates)

    updated_index = fn date_index ->
      (date_index == 0 && date_size - 1) || date_index - 1
    end

    {:noreply, update(socket, :date_index, updated_index)}
  end

  def handle_event("next", _, socket) do
    date_size = Enum.count(socket.assigns.dates)

    updated_index = fn date_index ->
      (date_index >= date_size - 1 && 0) || date_index + 1
    end

    {:noreply, update(socket, :date_index, updated_index)}
  end

  defp get_dates(summary) do
    summary
    |> Enum.map(& &1.date)
    |> Enum.sort(Date)
  end
end
