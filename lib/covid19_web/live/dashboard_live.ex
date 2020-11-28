defmodule Covid19Web.DashboardLive do
  @moduledoc false

  use Covid19Web, :live_view

  alias Covid19.Queries

  def mount(_params, _session, socket) do
    world_summary = Queries.world_summary()
    dates = Queries.processed_dates(:world)
    selected_index = -1

    assigns = %{
      world_summary: world_summary,
      dates: dates,
      selected_index: selected_index,
      summary_data: summary_data(world_summary, dates, selected_index),
      country_data: country_data(dates, selected_index),
      location_data: location_data(dates, selected_index)
    }

    {:ok, assign(socket, assigns)}
  end

  def handle_event("pick-date", %{"date" => date}, socket) do
    date = Timex.parse!(date, "{YYYY}-{0M}-{D}") |> Timex.to_date()
    index = Enum.find_index(socket.assigns.dates, & &1 == date)
    socket = assign(socket, :selected_index, index)

    %{assigns: %{world_summary: data, dates: dates, selected_index: index}} = socket
    assigns = %{
      summary_data: summary_data(data, dates, index),
      country_data: country_data(dates, index),
      location_data: location_data(dates, index)
    }

    {:noreply, assign(socket, assigns)}
  end

  def handle_event(direction, _, socket) do
    socket = update(socket, :selected_index, next_index(direction))

    %{assigns: %{world_summary: data, dates: dates, selected_index: index}} = socket
    assigns = %{
      summary_data: summary_data(data, dates, index),
      country_data: country_data(dates, index),
      location_data: location_data(dates, index)
    }

    {:noreply, assign(socket, assigns)}
  end

  defp next_index("oldest"), do: fn _ -> 0 end
  defp next_index("older"), do: fn idx -> idx - 1 end
  defp next_index("newest"), do: fn _ -> -1 end
  defp next_index("newer"), do: fn idx -> idx + 1 end

  defp summary_data(world_summary, dates, selected_index) do
    world_summary
    |> Enum.group_by(& &1.date)
    |> Map.get(Enum.at(dates, selected_index))
    |> Enum.at(0)
  end

  defp country_data(dates, selected_index) do
    Queries.summary_by_country(Enum.at(dates, selected_index))
  end

  defp location_data(dates, selected_index) do
    Queries.locations_for_date(Enum.at(dates, selected_index))
  end
end
