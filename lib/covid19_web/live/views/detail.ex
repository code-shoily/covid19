defmodule Covid19Web.Live.Views.Detail do
  use Phoenix.LiveView

  def mount(%{"country_or_region" => country_or_region}, _sessions, socket) do
    {:ok, socket |> assign(country_or_region: country_or_region)}
  end

  def render(assigns) do
    ~L"""
    <div>DETAIL VIEW OF <%= @country_or_region %></div>
    """
  end
end
