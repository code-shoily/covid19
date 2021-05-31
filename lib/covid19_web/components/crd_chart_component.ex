defmodule Covid19Web.CRDChartComponent do
  @moduledoc false

  use Covid19Web, :surface_live_component

  prop type, :string
  prop heading, :string
  prop data, :list

  data logarithmic, :boolean, default: false

  def render(assigns) do
    ~H"""
    <div
      class="card"
      :hook="CRDChart"
      data-type="{{ @type }}"
      data-statistics="{{ Jason.encode!(filter(@data, @type)) }}"
      data-logarithmic="{{ Jason.encode!(@logarithmic) }}">
      <div class="card-content">
        <p class="card-title">{{ @heading }}</p>
        <p class="subtitle text-base">
          {{ Helpers.format_date(Enum.at(@data, 0).date) }} - {{ Helpers.format_date(Enum.at(@data, -1).date) }}
        </p>
        <div phx-update="ignore">
          <p class="subtitle">Daily</p>
          <div id="new-{{ @type }}-chart" style="height: 180px"></div>
        </div>
        <hr />
        <div phx-update="ignore">
          <p class="subtitle">Cumulative</p>
          <div id="cumulative-{{ @type }}-chart" style="height: 180px"></div>
        </div>

        <div class="flex justify-center w-full pt-4">
          <button
              class="btn {{ button_class(@type) }}"
              :on-click="toggle-log-chart">
            {{ @logarithmic && "Show Linear" || "Show Logarithmic" }}
          </button>
        </div>
      </div>
    </div>
    """
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
    |> Enum.filter(fn [_, u, v] -> v > 0 and u > 0 end)
  end

  defp get_keys(type) do
    %{
      "confirmed" => {:confirmed, :new_confirmed},
      "deaths" => {:deaths, :new_deaths},
      "recovered" => {:recovered, :new_recovered}
    }[type]
  end

  defp button_class("confirmed"), do: "bg-blue-500 text-white"
  defp button_class("deaths"), do: "bg-red-500 text-white"
  defp button_class("recovered"), do: "bg-green-500 text-white"
end
