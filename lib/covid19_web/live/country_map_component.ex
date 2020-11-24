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
end
