defmodule Covid19Web.CountrywiseSummaryComponent do
  @moduledoc false

  alias Covid19Web.DetailLive

  use Covid19Web, :surface_live_component

  def mount(socket) do
    {:ok,
     socket
     |> assign(by: :country_or_region)
     |> assign(dir: :asc)
     |> assign(term: "")}
  end

  def handle_event("sort", %{"by" => by}, socket) do
    {:noreply,
     socket
     |> update(:dir, fn
       :asc -> :desc
       :desc -> :asc
     end)
     |> assign(by: String.to_atom(by))}
  end

  def handle_event("filter", %{"term" => term}, socket) do
    {:noreply, socket |> assign(term: term)}
  end

  def handle_event("clear-term", _, socket) do
    {:noreply, socket |> assign(term: "")}
  end

  defp sorted(data, by, dir, term, :country_or_region) do
    data
    |> Enum.sort_by(& &1[by], dir)
    |> Enum.filter(fn %{country_or_region: country_or_region} ->
      String.contains?(
        String.downcase(country_or_region),
        String.downcase(term)
      )
    end)
    |> Enum.with_index(1)
  end

  defp sorted(data, by, dir, term, :province_or_state) do
    data
    |> Enum.sort_by(& &1[by], dir)
    |> Enum.filter(fn %{province_or_state: province_or_state} ->
      String.contains?(
        String.downcase(province_or_state),
        String.downcase(term)
      )
    end)
    |> Enum.with_index(1)
  end

  defp show_sort_icon(col, by, dir) do
    if col == by do
      case dir do
        :asc ->
          ~E"""
            <i class="fas fa-long-arrow-alt-up"></i>
          """

        _ ->
          ~E"""
            <i class="fas fa-long-arrow-alt-down"></i>
          """
      end
    end
  end
end
