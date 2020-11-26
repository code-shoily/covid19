defmodule Covid19Web.TimelineComponent do
  @moduledoc false

  use Covid19Web, :live_component

  @events [
    {"is-success", "March 13, 2020", "Started development"},
    {"is-success", "April 15, 2020", "Finished scraper for John Hopkins dataset"},
    {"is-info", "November 1, 2020", "New update after 7 months of hiatus"},
    {"is-warning", "November 22, 2020",
     "Add incidence rate and case fatality ratio. Implement cache PoC"},
    {"is-warning", "November 24, 2020", "Major overhaul of file structure"},
    {"is-success", "November 26, 2020", "Upgrade Dashboard. Release version 0.6"}
  ]

  def mount(socket) do
    {:ok, assign(socket, :events, @events)}
  end

  def render(assigns) do
    ~L"""
    <div class="card">
      <div class="card-content">
        <p class="title is-5">Project Timeline</p>
        <div class="timeline">
          <%= for {class, date, description} <- @events do %>
            <div class="timeline-item">
              <div class="timeline-marker <%= class %>">
              </div>
              <div class="timeline-content">
                <p class="heading"><%= date %></p>
                <p><%= description %></p>
              </div>
            </div>
          <% end %>
        </div>
      </div>
    </div>
    """
  end
end
