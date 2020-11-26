defmodule Covid19Web.DashboardLive do
  @moduledoc false

  use Covid19Web, :live_view

  alias Covid19Web.{
    CaseChartComponent,
    CountryMapComponent,
    CountrywiseSummaryComponent,
    DashboardControlComponent,
    DeathChartComponent,
    PieChartComponent,
    RecoveredChartComponent,
    TimelineComponent,
    WorldByDayComponent,
    WorldSummaryComponent
  }

  alias Covid19.Queries

  def mount(_params, _session, socket) do
    world_summary = Queries.world_summary()
    dates = Queries.processed_dates(:world)
    selected_index = -1

    socket =
      socket
      |> assign(
        world_summary: world_summary,
        dates: dates,
        selected_index: selected_index
      )

    {:ok, socket}
  end

  def handle_event("older", _, socket) do
    {:noreply, update(socket, :selected_index, fn index -> index - 1 end)}
  end

  def handle_event("oldest", _, socket) do
    {:noreply, assign(socket, :selected_index, 0)}
  end

  def handle_event("newer", _, socket) do
    {:noreply, update(socket, :selected_index, fn index -> index + 1 end)}
  end

  def handle_event("newest", _, socket) do
    {:noreply, assign(socket, :selected_index, -1)}
  end

  def handle_event("pick-date", %{"date" => date}, socket) do
    selected_date = Timex.parse!(date, "{YYYY}-{0M}-{D}") |> Timex.to_date()

    selected_index =
      socket.assigns.dates |> Enum.find_index(fn value -> value == selected_date end)

    {:noreply, assign(socket, :selected_index, selected_index)}
  end

  defp data_for_selected_date(world_summary, dates, selected_index) do
    world_summary = Enum.group_by(world_summary, & &1.date)
    hd(world_summary[Enum.at(dates, selected_index)])
  end

  defp country_data_for_selected_date(dates, selected_index) do
    Queries.summary_by_country(Enum.at(dates, selected_index))
  end

  defp location_data_for_selected_date(dates, selected_index) do
    Queries.locations_for_date(Enum.at(dates, selected_index))
  end
end
