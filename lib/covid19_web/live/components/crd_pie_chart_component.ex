defmodule Covid19Web.CRDPieChartComponent do
  @moduledoc false

  use Covid19Web, :live_component

  def render(assigns) do
    ~L"""
    <div class="card" phx-hook="CRDPieChart" data-statistics="<%= Jason.encode! @data %>">
      <div class="card-content">
        <p class="title is-5 is-uppercase has-text-centered"><%= @heading %></p>
        <div phx-update="ignore">
          <p class="title is-6 is-uppercase has-text-centered">Per Day</p>
          <div id="new-pie-chart" style="height: 250px"></div>
        </div>
        <hr />
        <div phx-update="ignore">
          <p class="title is-6 is-uppercase has-text-centered">Total</p>
          <div id="total-pie-chart" style="height: 250px"></div>
        </div>
      </div>
    </div>
    """
  end
end
