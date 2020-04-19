defmodule Covid19Web.Live.Components.WorldSummary do
  use Phoenix.LiveComponent

  defp fmt(number) when is_number(number) do
    Number.Delimit.number_to_delimited(number, precision: 0)
  end

  defp fmt(%Date{} = date) do
    Timex.format!(date, "%B %d, %Y", :strftime)
  end

  def render(assigns) do
    ~L"""
    <div class="card">
      <div class="card-content">
        <p class="title is-5 has-text-centered is-uppercase">World Summary</p>
        <p class="subtitle is-6 has-text-centered"><%= @data.date |> fmt() %></p>
        <table class="table is-fullwidth">
          <tbody>
              <tr>
                  <th class="has-text-left">Confirmed</th>
                  <td class="has-text-right"><%= @data.confirmed |> fmt() %></td>
              </tr>
              <tr>
                  <th class="has-text-left">Recovered</th>
                  <td class="has-text-right"><%= @data.recovered |> fmt() %></td>
              </tr>
              <tr>
                  <th class="has-text-left">Active</th>
                  <td class="has-text-right"><%= @data.active |> fmt() %></td>
              </tr>
              <tr>
                  <th class="has-text-left">Deaths</th>
                  <td class="has-text-right"><%= @data.deaths |> fmt() %></td>
              </tr>
          </tbody>
        </table>
      </div>
      <footer class="card-footer">
        <a href="#" style="border: 0" class="card-footer-item has-background-primary  has-text-light" phx-click="oldest">
          <i class="fas fa-fast-backward"></i>
        </a>
        <a style="border: 0" href="#" class="card-footer-item has-background-info  has-text-light" phx-click="older">
          <i class="fas fa-backward"></i>
        </a>
        <a style="border: 0" href="#" class="card-footer-item has-background-info  has-text-light" phx-click="newer">
          <i class="fa fa-forward"></i>
        </a>
        <a style="border: 0" href="#" class="card-footer-item has-background-primary  has-text-light" phx-click="newest">
          <i class="fas fa-fast-forward"></i>
        </a>
      </footer>
    </div>
    """
  end
end
