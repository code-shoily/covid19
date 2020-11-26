defmodule Covid19Web.ControlComponent do
  @moduledoc false

  alias Covid19Web.CalendarComponent

  use Covid19Web, :live_component

  def render(assigns) do
    ~L"""
    <div class="card">
      <div class="card-content">
        <%= live_component @socket,
          CalendarComponent,
          id: "calendar_component",
          current_date: Enum.at(@dates, @selected_index),
          dates: @dates |> MapSet.new() %>
        <hr />
        <div class="buttons has-addons is-centered">
          <button class="button is-danger is-small" phx-click="oldest">
            <span class="icon">
              <i class="fas fa-angle-double-left"></i>
            </span>
            <span>Start</span>
          </button>
          <button class="button is-info is-small" phx-click="older">
            <span class="icon">
              <i class="fas fa-angle-left"></i>
            </span>
            <span>Prev</span>
          </button>
          <button class="button is-info is-small" phx-click="newer">
            <span>Next</span>
            <span class="icon">
              <i class="fas fa-angle-right"></i>
            </span>
          </button>
          <button class="button is-danger is-small" phx-click="newest">
            <span>End</span>
            <span class="icon">
              <i class="fas fa-angle-double-right"></i>
            </span>
          </button>
        </div>
      </div>
    </div>
    """
  end
end
