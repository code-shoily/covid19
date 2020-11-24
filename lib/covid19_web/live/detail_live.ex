defmodule Covid19Web.DetailLive do
  use Phoenix.LiveView

  def mount(%{"country_or_region" => country_or_region}, _sessions, socket) do
    {:ok, socket |> assign(country_or_region: country_or_region)}
  end
end
