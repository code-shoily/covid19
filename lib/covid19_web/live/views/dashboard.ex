defmodule Covid19Web.Live.Views.Dashboard do
  use Phoenix.LiveView

  alias Covid19Web.Live.Components.WorldSummary
  alias Covid19.Queries

  def mount(_params, _session, socket) do
    data = Queries.world_summary_by_date(~D[2020-04-15])
    socket =
      socket
      |> assign(world_summary: data)
    {:ok, socket}
  end

  def render(assigns) do
    ~L"""
    <div class="container is-fluid">
      <div class="columns">
        <div class="column is-one-quarter">
          <div class="columns">
            <div class="column">
              <%= live_component @socket, WorldSummary, id: :world_summary, data: @world_summary %>
            </div>
          </div>
        </div>
      </div>
    </div>
    """
  end
end
