defmodule Covid19Web.CountryMapComponent do
  @moduledoc false

  use Covid19Web, :live_component

  def mount(socket) do
    {:ok, socket |> assign(:selected, :active)}
  end

  def handle_event("take-" <> value, _, socket) do
    {:noreply, socket |> assign(:selected, String.to_atom(value))}
  end

  defp maybe_selected(:deaths, :deaths), do: "is-danger"
  defp maybe_selected(:recovered, :recovered), do: "is-success"
  defp maybe_selected(a, a), do: "is-primary"
  defp maybe_selected(_, _), do: ""

  defp filter(data, selected) do
    data
    |> Enum.map(fn data ->
      data
      |> Map.take([:latitude, :longitude, :confirmed, :recovered, :active, :deaths])
      |> Map.put_new(:count, Enum.random([0, 100]))
    end)
    |> Enum.filter(fn data ->
      Map.has_key?(data, :longitude) and Map.has_key?(data, :latitude)
    end)
    |> Enum.map(fn data ->
      data |> Map.update(:count, 0, fn _ -> data[selected] end)
    end)
    |> Enum.reject(fn data -> data.active == 0 end)
  end

  def render(assigns) do
    ~L"""
    <div class="card" phx-hook="LeafletMap" data-locations="<%= @data |> filter(@selected) |> Jason.encode!() %>">
      <div class="card-content">
        <div class="level">
          <div class="level-left">
            <p class="level-item title is-5 is-uppercase">World Map</p>
          </div>
          <div class="level-right">
            <div class="buttons has-addons">
              <button phx-click="take-confirmed" phx-target="<%= @myself %>" class="button is-small <%= maybe_selected(:confirmed, @selected) %>">Confirmed</button>
              <button phx-click="take-active" phx-target="<%= @myself %>" class="button is-small <%= maybe_selected(:active, @selected) %>">Active</button>
              <button phx-click="take-recovered" phx-target="<%= @myself %>" class="button is-small <%= maybe_selected(:recovered, @selected) %>">Recovered</button>
              <button phx-click="take-deaths" phx-target="<%= @myself %>" class="button is-small <%= maybe_selected(:deaths, @selected) %>">Deaths</button>
            </div>
          </div>
        </div>
        <div phx-update="ignore">
          <div
            id="map"
            class="is-fullwidth"
            style="height: 550px">
          </div>
        </div>
      </div>
    </div>
    """
  end
end
