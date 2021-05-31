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
          current_date= {{ Enum.at(@dates, @selected_index) }}
          dates={{ MapSet.new(@dates) }} />
        <hr />
        <div class="button-group flex mt-4 justify-center">
          <button class="button-left" :on-click={{ @oldest }}>
            <span class="icon">
              <i class="fas fa-angle-double-left"></i>
            </span>
            <span>Start</span>
          </button>
          <button class="button" :on-click={{ @older }}>
            <span class="icon">
              <i class="fas fa-angle-left"></i>
            </span>
            <span>Prev</span>
          </button>
          <button class="button" :on-click={{ @newer }}>
            <span>Next</span>
            <span class="icon">
              <i class="fas fa-angle-right"></i>
            </span>
          </button>
          <button class="button-right" :on-click={{ @newest }}>
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
