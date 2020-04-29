defmodule Covid19Web.Live.Components.WorldByDay do
  import Phoenix.HTML

  use Phoenix.LiveComponent

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

  def render(assigns) do
    ~L"""
    <div class="card">
      <div class="card-content">
        <p class="title is-5 is-uppercase">World Summary by Date</p>
        <div class="table-container" style="height: 400px; overflow: auto">
        <table class="table is-striped is-narrow is-fullwidth">
          <thead>
            <tr>
              <th>#</th>
              <th>
                <a href="#"
                  phx-click="sort"
                  phx-value-by="date"
                  phx-target="<%= @myself %>"
                >
                  Date <%= show_sort_icon(:date, @by, @dir) %>
                </a>
              </th>
              <th class="has-text-right">
                <a href="#"
                  phx-click="sort"
                  phx-value-by="confirmed"
                  phx-target="<%= @myself %>">
                  Confirmed <%= show_sort_icon(:confirmed, @by, @dir) %>
                </a>
              </th>
              <th class="has-text-right">
                <a href="#" phx-click="sort" phx-value-by="new_confirmed" phx-target="<%= @myself %>">
                  New Cases <%= show_sort_icon(:new_confirmed, @by, @dir) %>
                </a>
              </th>
              <th class="has-text-right">
                <a href="#" phx-click="sort" phx-value-by="active" phx-target="<%= @myself %>">
                  Active <%= show_sort_icon(:active, @by, @dir) %>
                </a>
              </th>
              <th class="has-text-centered">
                <a href="#" phx-click="sort" phx-value-by="recovered" phx-target="<%= @myself %>">
                  Recovered <%= show_sort_icon(:recovered, @by, @dir) %>
                </a>
              </th>
              <th class="has-text-centered">
                <a href="#" phx-click="sort" phx-value-by="deaths" phx-target="<%= @myself %>">
                  Deaths <%= show_sort_icon(:deaths, @by, @dir) %>
                </a>
              </th>
              <th class="has-text-centered">
                <a href="#" phx-click="sort" phx-value-by="new_deaths" phx-target="<%= @myself %>">
                  New Deaths <%= show_sort_icon(:new_deaths, @by, @dir) %>
                </a>
              </th>
            </tr>
          </thead>
          <tbody>
            <%= for {d, idx} <- sorted(@data, @by, @dir) do %>
              <tr>
                <td><%= idx %></td>
                <td><%= d.date |> fmt() %></td>
                <td class="has-text-weight-semibold has-text-right"><%= d.confirmed |> fmt() %></td>
                <td class="has-text-weight-semibold has-text-right"><%= d.new_confirmed |> fmt() %></td>
                <td class="has-text-weight-semibold has-text-right"><%= d.active |> fmt() %></td>
                <td class="has-background-primary has-text-weight-semibold has-text-centered"><%= d.recovered |> fmt() %></td>
                <td class="has-text-weight-semibold has-text-centered"><%= d.deaths |> fmt() %></td>
                <td class="has-background-danger has-text-weight-semibold has-text-centered"><%= d.new_deaths |> fmt() %></td>
              </tr>
            <% end %>
          </tbody>
        </table>
        </div>
      </div>
    </div>
    """
  end

  defp fmt(number) when is_number(number) do
    Number.Delimit.number_to_delimited(number, precision: 0)
  end

  defp fmt(%Date{} = date) do
    Timex.format!(date, "%b %d, %Y", :strftime)
  end

  defp fmt(anything), do: anything

  defp sorted(data, by, dir) do
    data
    |> Enum.sort_by(& &1[by], dir)
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
