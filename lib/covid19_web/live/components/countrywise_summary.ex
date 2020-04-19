defmodule Covid19Web.Live.Components.CountrywiseSummary do
  use Phoenix.LiveComponent

  defp fmt(number) when is_number(number) do
    Number.Delimit.number_to_delimited(number, precision: 0)
  end

  def render(assigns) do
    ~L"""
    <div class="card">
      <div class="card-content">
        <p class="title is-5 is-uppercase">Countrywise Summary</p>

        <table class="table is-fullwidth">
          <thead>
            <tr>
              <th>Country/Region</th>
              <th>Confirmed</th>
              <th class="has-text-right">New Cases</th>
              <th>Active</th>
              <th class="has-text-centered">Recovered</th>
              <th>Deaths</th>
              <th class="has-text-centered">New Deaths</th>
            </tr>
          </thead>
          <tbody>
            <%= for d <- @data do %>
              <tr>
                <td><%= d.country_or_region %></td>
                <td class="has-text-weight-semibold"><%= d.confirmed |> fmt() %></td>
                <td class="has-text-weight-semibold has-text-right"><%= d.new_confirmed |> fmt() %></td>
                <td class="has-text-weight-semibold has-text-right"><%= d.active |> fmt() %></td>
                <td class="has-background-primary has-text-weight-semibold has-text-centered"><%= d.recovered |> fmt() %></td>
                <td class="has-text-weight-semibold"><%= d.deaths |> fmt() %></td>
                <td class="has-background-danger has-text-weight-semibold has-text-centered"><%= d.new_deaths |> fmt() %></td>
              </tr>
            <% end %>
          </tbody>
        </table>
      </div>
    </div>
    """
  end
end
