defmodule Covid19Web.DailyTableComponent do
  @moduledoc false

  use Covid19Web, :surface_live_component

  prop data, :list
  prop type_heading, :string
  prop type_name, :string
  prop type_attr, :atom

  def mount(socket) do
    {:ok,
     socket
     |> assign(by: :date)
     |> assign(dir: :asc)}
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

  defp sorted(data, by, dir) do
    data
    |> Enum.sort_by(& &1[by], (by == :date && {dir, Date}) || dir)
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
