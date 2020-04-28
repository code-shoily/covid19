defmodule Covid19Web.Live.Components.NewCaseChart do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~L"""
    <div
      class="card"
      phx-hook="NewCaseChart"
      data-statistics="<%= Jason.encode! @data %>"
    >
      <div class="card-content">
        <p class="title is-5 is-uppercase has-text-centered">New Cases</p>
        <p class="subtitle is-6 is-uppercase has-text-centered has-text-monospace">
          <%= Enum.at(@data, 0).date |> fmt() %> -
          <%= Enum.at(@data, -1).date |> fmt() %>
        </p>
        <div phx-update="ignore">
          <div id="new-case-chart" style="height: 200px"></div>
        </div>
      </div>
    </div>
    """
  end

  defp fmt(%Date{} = date) do
    Timex.format!(date, "%b %d, %Y", :strftime)
  end
end
