defmodule Covid19Web.CountryMapComponent do
  @moduledoc false

  alias Covid19.Queries

  use Covid19Web, :surface_live_component

  prop dates, :list
  prop selected_index, :integer

  data data, :list, default: []
  data selected, :atom, default: :active

  def update(%{dates: dates, selected_index: selected_index} = assigns, socket) do
    locations = location_data(dates, selected_index)
    assigns = Map.merge(assigns, %{data: locations})
    {:ok, assign(socket, assigns)}
  end

  def render(assigns) do
    ~H"""
    <div
      class="card"
      :hook="HeatMap"
      data-locations="{{ @data |> filter(@selected) |> Jason.encode!() }}"
    >
      <div class="card-content">
        <div class="level">
          <div class="level-left">
            <p class="level-item title is-5 is-uppercase">World Map</p>
          </div>
          <div class="level-right">
            <div class="buttons has-addons">
              <button
                :on-click="confirmed"
                class="button is-small has-text-weight-semibold {{ maybe_selected(:confirmed, @selected) }}"
              >
                Confirmed
              </button>
              <button
                :on-click="active"
                class="button is-small has-text-weight-semibold {{ maybe_selected(:active, @selected) }}"
              >
                Active
              </button>
              <button
                :on-click="recovered"
                class="button is-small has-text-weight-semibold {{ maybe_selected(:recovered, @selected) }}"
              >
                Recovered
              </button>
              <button
                :on-click="deaths"
                class="button is-small has-text-weight-semibold {{ maybe_selected(:deaths, @selected) }}"
              >
                Deaths
              </button>
            </div>
          </div>
        </div>
        <div phx-update="ignore">
          <div id="map" class="is-fullwidth" style="height: 550px" />
        </div>
      </div>
    </div>
    """
  end

  def handle_event(value, _, socket) do
    {:noreply, socket |> assign(:selected, String.to_atom(value))}
  end

  defp location_data(dates, selected_index) do
    dates
    |> Enum.at(selected_index)
    |> Queries.locations_for_date()
  end

  defp maybe_selected(:deaths, :deaths), do: "is-danger"
  defp maybe_selected(:recovered, :recovered), do: "is-success"
  defp maybe_selected(a, a), do: "is-info"
  defp maybe_selected(_, _), do: ""

  defp filter(data, selected) do
    data
    |> Enum.filter(fn data ->
      Map.has_key?(data, :longitude) and Map.has_key?(data, :latitude) and data.active > 0
    end)
    |> Enum.map(&process_location(&1, selected))
  end

  defp process_location(location, selected) do
    location
    |> Map.take([:latitude, :longitude, :confirmed, :recovered, :active, :deaths])
    |> Map.put_new(:count, 0)
    |> Map.update(:count, 0, fn _ -> location[selected] end)
    |> (fn map -> [map.count, map.latitude, map.longitude] end).()
  end
end
