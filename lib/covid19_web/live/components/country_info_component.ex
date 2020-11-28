defmodule Covid19Web.CountryInfoComponent do
  use Covid19Web, :live_component

  def render(assigns) do
    ~L"""
    <div class="card">
      <div class="card-content has-text-centered">
        <p class="title is-6">
          <%= Helpers.format_date(@date) %>
        </p>
        <p class="title is-3">
          <%= @country[:name] %>
        </p>
        <p class="subtitle">
          <%= @country[:continent] %>
        </p>
        <p>
          <%= live_patch "Back to World Data",
            to: Routes.live_path(@socket, Covid19Web.DashboardLive) %>
        </p>
      </div>
    </div>
    """
  end
end
