defmodule Covid19Web.CalendarComponent do
  @moduledoc false

  alias Covid19Web.CalendarDayComponent

  use Covid19Web, :live_component
  use Timex

  @week_start_at :mon

  def update(%{current_date: current_date} = assigns, socket) do
    assigns =
      Map.merge(assigns, %{
        cursor_date: current_date,
        day_names: day_names(@week_start_at),
        week_rows: week_rows(current_date)
      })

    {:ok, assign(socket, assigns)}
  end

  defp day_names(:mon), do: [7, 1, 2, 3, 4, 5, 6] |> Enum.map(&Timex.day_shortname/1)

  defp week_rows(current_date) do
    first =
      current_date
      |> Timex.beginning_of_month()
      |> Timex.beginning_of_week(@week_start_at)

    last =
      current_date
      |> Timex.end_of_month()
      |> Timex.end_of_week(@week_start_at)

    Interval.new(from: first, until: last)
    |> Enum.map(& &1)
    |> Enum.chunk_every(7)
  end

  def handle_event("prev-month", _, socket) do
    cursor_date = Timex.shift(socket.assigns.cursor_date, months: -1)

    assigns = [
      cursor_date: cursor_date,
      week_rows: week_rows(cursor_date)
    ]

    {:noreply, assign(socket, assigns)}
  end

  def handle_event("next-month", _, socket) do
    cursor_date = Timex.shift(socket.assigns.cursor_date, months: 1)

    assigns = [
      cursor_date: cursor_date,
      week_rows: week_rows(cursor_date)
    ]

    {:noreply, assign(socket, assigns)}
  end
end
