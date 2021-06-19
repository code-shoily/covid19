defmodule Covid19Web.CountryInfoComponent do
  @moduledoc false

  use Covid19Web, :surface_component

  prop date, :date
  prop country, :map

  def render(assigns) do
    ~F"""
    <div class="card">
      <div class="card-content has-text-centered">
        <p class="title is-6">
          {Helpers.format_date(@date)}
        </p>
        <p class="title is-3">
          {@country[:name]}
        </p>
        <p class="subtitle">
          {@country[:continent]}
        </p>
        <p>
          <LivePatch label="Back to World Data" to="/" />
        </p>
      </div>
    </div>
    """
  end
end
