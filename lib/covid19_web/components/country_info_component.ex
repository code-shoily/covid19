defmodule Covid19Web.CountryInfoComponent do
  @moduledoc false

  use Covid19Web, :surface_component

  prop date, :date
  prop country, :map

  def render(assigns) do
    ~H"""
    <div class="info-card bg-gray-600 text-white">
        <div class="heading">
          {{ Helpers.format_date(@date) }}
        </div>
        <div class="value">
          {{ @country[:name] }}
        </div>
        <div class="sub-value">
          {{ @country[:continent] }}
        </div>
        <div class="text-sm pt-4 text-blue-200">
          <LivePatch label="Back to World Data" to="/" />
        </div>
    </div>
    """
  end
end
