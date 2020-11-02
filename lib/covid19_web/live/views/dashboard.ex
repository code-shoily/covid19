defmodule Covid19Web.Live.Views.Dashboard do
  use Phoenix.LiveView

  alias Covid19Web.Live.Components.{
    DeathRecoveredChart,
    CountryMap,
    CountrywiseSummary,
    NewCaseChart,
    WorldSummary,
    WorldByDay
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

  def render(assigns) do
    ~L"""
    <div class="container is-fluid">
      <div class="columns is-desktop">
        <div class="column is-one-quarter-widescreen is-one-third-desktop">
          <div class="columns">
            <div class="column">
              <%= live_component @socket,
                WorldSummary,
                id: :world_summary,
                data: data_for_selected_date(@world_summary, @dates, @selected_index)
              %>
            </div>
          </div>
          <div class="columns">
            <div class="column">
              <%= live_component @socket,
                NewCaseChart,
                id: :new_case_chart,
                data: @world_summary %>
            </div>
          </div>
          <div class="columns">
            <div class="column">
              <%= live_component @socket,
                DeathRecoveredChart,
                id: :death_recovered_chart,
                data: @world_summary %>
            </div>
          </div>
        </div>
        <div class="column">
          <div class="columns">
              <div class="column">
                <%= live_component @socket,
                  CountrywiseSummary,
                  id: :countrywise_summary,
                  data: country_data_for_selected_date(@dates, @selected_index)
                %>
              </div>
          </div>
          <div class="columns">
            <div class="column">
              <%= live_component @socket,
                CountryMap,
                id: :country_map,
                data: location_data_for_selected_date(@dates, @selected_index)
              %>
            </div>
          </div>
          <div class="columns">
            <div class="column">
              <%= live_component @socket,
                WorldByDay,
                id: :world_by_day,
                data: @world_summary
              %>
            </div>
          </div>
        </div>
      </div>
    </div>
    """
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
