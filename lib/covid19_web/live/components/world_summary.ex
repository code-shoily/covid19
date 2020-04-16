defmodule Covid19Web.Live.Components.WorldSummary do
  use Phoenix.LiveComponent

  def handle_event("dec", _, socket) do
    send(self(), {:change, socket.assigns.id, -1})
    {:noreply, socket}
  end

  def handle_event("inc", _, socket) do
    send(self(), {:change, socket.assigns.id, 1})
    {:noreply, socket}
  end

  defp fmt(number) do
    Number.Delimit.number_to_delimited(number, precision: 0)
  end

  def render(assigns) do
    ~L"""
    <div class="uk-card uk-card-primary uk-card-small uk-card-default uk-card-body">
      <h3 class="uk-card-title">World Summary</h3>
      <table class="uk-table uk-table-divider uk-table-small uk-table-justify">
        <tbody>
            <tr>
                <th>Confirmed</th>
                <td><%= @data.confirmed |> fmt() %></td>
            </tr>
            <tr>
                <th>Recovered</th>
                <td><%= @data.recovered |> fmt() %></td>
            </tr>
            <tr>
                <th>Active</th>
                <td><%= @data.active |> fmt() %></td>
            </tr>
            <tr>
                <th>Deaths</th>
                <td><%= @data.deaths |> fmt() %></td>
            </tr>
        </tbody>
      </table>
    </div>
    """
  end
end
