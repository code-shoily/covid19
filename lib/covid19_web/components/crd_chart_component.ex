defmodule Covid19Web.CRDChartComponent do
  @moduledoc false

  use Covid19Web, :surface_live_component

  prop type, :string
  prop heading, :string
  prop data, :list

  data logarithmic, :boolean, default: false

  def render(assigns) do
    ~F"""
    <div
      class="card"
      phx-hook="CRDChart"
      data-type={@type}
      data-statistics={Jason.encode!(filter(@data, @type))}
      data-logarithmic={Jason.encode!(@logarithmic)}
    >
      <div class="card-content">
        <p class="title is-5 is-uppercase has-text-centered">{@heading}</p>
        <p class="subtitle is-6 is-uppercase has-text-centered has-text-monospace">
          {Helpers.format_date(Enum.at(@data, 0).date)} - {Helpers.format_date(Enum.at(@data, -1).date)}
        </p>
        <div phx-update="ignore">
          <p class="title is-6 is-uppercase has-text-centered">Daily</p>
          <div id={get_new_id_for(@type)} style="height: 180px" />
        </div>
        <hr>
        <div phx-update="ignore">
          <p class="title is-6 is-uppercase has-text-centered">Cumulative</p>
          <div id={get_cumulative_id_for(@type)} style="height: 180px" />
        </div>

        <p class="has-text-centered has-text-monospace">
          <button class={"button is-small", button_class(@type)} :on-click="toggle-log-chart">
            {(@logarithmic && "Show Linear") || "Show Logarithmic"}
          </button>
        </p>
      </div>
    </div>
    """
  end

  def get_new_id_for(type) do
    "new-" <> type <> "-chart"
  end

  def get_cumulative_id_for(type) do
    "cumulative-" <> type <> "-chart"
  end

  def handle_event("toggle-log-chart", _, socket) do
    {:noreply, update(socket, :logarithmic, &Kernel.not/1)}
  end

  defp filter(data, type) do
    {cumulative, new} = get_keys(type)

    data
    |> Enum.map(fn map ->
      map =
        map
        |> Map.take([:date, cumulative, new])

      [map.date, map[cumulative], map[new]]
    end)
    |> Enum.filter(fn [_, u, v] -> v > 0 and u > 0 and not is_nil(v) end)
  end

  defp get_keys(type) do
    %{
      "confirmed" => {:confirmed, :new_confirmed},
      "deaths" => {:deaths, :new_deaths},
      "recovered" => {:recovered, :new_recovered}
    }[type]
  end

  defp button_class("confirmed"), do: "is-info"
  defp button_class("deaths"), do: "is-danger"
  defp button_class("recovered"), do: "is-success"
end
