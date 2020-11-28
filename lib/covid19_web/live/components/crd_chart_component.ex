defmodule Covid19Web.CRDChartComponent do
  @moduledoc false

  use Covid19Web, :live_component

  def mount(socket) do
    {:ok, assign(socket, logarithmic: false)}
  end

  def handle_event("toggle-log-chart", _, socket) do
    {:noreply, update(socket, :logarithmic, &Kernel.not/1)}
  end

  def render(assigns) do
    ~L"""
    <div
      class="card"
      phx-hook="CRDChart"
      data-type="<%= @type %>"
      data-statistics="<%= Jason.encode!(@data) %>"
      data-logarithmic="<%= Jason.encode!(@logarithmic) %>">
      <div class="card-content">
        <p class="title is-5 is-uppercase has-text-centered"><%= @heading %></p>
        <p class="subtitle is-6 is-uppercase has-text-centered has-text-monospace">
          <%= Helpers.format_date(Enum.at(@data, 0).date) %> - <%= Helpers.format_date(Enum.at(@data, -1).date) %>
        </p>
        <div phx-update="ignore">
          <p class="title is-6 is-uppercase has-text-centered">Daily</p>
          <div id="new-<%= @type %>-chart" style="height: 180px"></div>
        </div>
        <hr />
        <div phx-update="ignore">
          <p class="title is-6 is-uppercase has-text-centered">Cumulative</p>
          <div id="cumulative-<%= @type %>-chart" style="height: 180px"></div>
        </div>

        <p class="has-text-centered has-text-monospace">
          <button
              class="button is-small <%= button_class(@type) %>"
              phx-click="toggle-log-chart" phx-target="<%= @myself %>">
            <%= @logarithmic && "Show Linear" || "Show Logarithmic" %>
          </button>
        </p>
      </div>
    </div>
    """
  end

  defp button_class("confirmed"), do: "is-info"
  defp button_class("deaths"), do: "is-danger"
  defp button_class("recovered"), do: "is-success"
end
