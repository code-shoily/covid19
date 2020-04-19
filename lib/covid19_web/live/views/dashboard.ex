defmodule Covid19Web.Live.Views.Dashboard do
  use Phoenix.LiveView

  alias Covid19Web.Live.Components.WorldSummary
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

  def render(assigns) do
    ~L"""
    <div class="container is-fluid" style="margin-top: 40px">
      <div class="columns">
        <div class="column is-one-quarter">
          <div class="columns">
            <div class="column">
              <%= live_component @socket,
                WorldSummary,
                id: :world_summary,
                data: data_for_selected_date(@world_summary, @dates, @selected_index)
              %>
            </div>
          </div>
        </div>
      </div>
    </div>
    """
  end

  defp data_for_selected_date(world_summary, dates, selected_index) do
    hd(world_summary[Enum.at(dates, selected_index)])
  end
end
