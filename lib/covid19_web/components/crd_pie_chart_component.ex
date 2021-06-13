defmodule Covid19Web.CRDPieChartComponent do
  @moduledoc false

  use Covid19Web, :surface_component

  prop did, :string
  prop data, :map, required: true
  prop heading, :string, required: true

  def render(assigns) do
    ~H"""
    <div id={{ @did }} class="card" :hook="CRDPieChart" data-statistics="{{ Jason.encode!(@data) }}">
      <div class="card-content">
        <p class="title is-5 is-uppercase has-text-centered">{{ @heading }}</p>
        <div phx-update="ignore">
          <p class="title is-6 is-uppercase has-text-centered">Per Day</p>
          <div id="new-pie-chart" style="height: 250px" />
        </div>
        <hr>
        <div phx-update="ignore">
          <p class="title is-6 is-uppercase has-text-centered">Total</p>
          <div id="total-pie-chart" style="height: 250px" />
        </div>
      </div>
    </div>
    """
  end
end
