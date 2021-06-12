defmodule Covid19Web.ControlComponent do
  @moduledoc false

  alias Covid19Web.CalendarComponent

  use Covid19Web, :surface_component

  prop selected_index, :integer
  prop current_date, :date
  prop dates, :any
  prop oldest, :event
  prop older, :event
  prop newest, :event
  prop newer, :event

  def render(assigns) do
    ~H"""
    <div class="card">
      <div class="card-content">
        <CalendarComponent
          id="calendar_component"
          current_date={{ Enum.at(@dates, @selected_index) }}
          dates={{ MapSet.new(@dates) }}
        />
        <hr>
        <div class="buttons has-addons is-centered">
          <button class="button is-danger is-small has-text-weight-semibold" :on-click={{ @oldest }}>
            <span class="icon">
              <i class="fas fa-angle-double-left" />
            </span>
            <span>Start</span>
          </button>
          <button class="button is-info is-small has-text-weight-semibold" :on-click={{ @older }}>
            <span class="icon">
              <i class="fas fa-angle-left" />
            </span>
            <span>Prev</span>
          </button>
          <button class="button is-info is-small has-text-weight-semibold" :on-click={{ @newer }}>
            <span>Next</span>
            <span class="icon">
              <i class="fas fa-angle-right" />
            </span>
          </button>
          <button class="button is-danger is-small has-text-weight-semibold" :on-click={{ @newest }}>
            <span>End</span>
            <span class="icon">
              <i class="fas fa-angle-double-right" />
            </span>
          </button>
        </div>
      </div>
    </div>
    """
  end
end
