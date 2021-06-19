defmodule Covid19Web.CalendarDayComponent do
  @moduledoc false

  use Covid19Web, :surface_component
  use Timex

  prop dates, :any
  prop day, :any
  prop current_date, :any
  prop cursor_date, :any
  prop day_class, :any, required: false

  def render(assigns) do
    assigns = Map.put(assigns, :day_class, day_class(assigns))

    valid_cell = ~F"""
    <td
      phx-click="pick-date"
      phx-value-date="{Timex.format!(@day, "%Y-%m-%d", :strftime)}"
      class="{@day_class}  has-text-centered" style="cursor: pointer">
      {Timex.format!(@day, "%d", :strftime)}
    </td>
    """

    invalid_cell = ~F"""
    <td class="{@day_class}  has-text-centered">
      {Timex.format!(@day, "%d", :strftime)}
    </td>
    """

    (invalid?(assigns.day_class) && invalid_cell) || valid_cell
  end

  defp invalid?("has-text-grey-light"), do: true
  defp invalid?(_), do: false

  defp day_class(assigns) do
    cond do
      invalid_date?(assigns) ->
        "has-text-grey-light"

      today?(assigns) ->
        "has-text-primary"

      current_date?(assigns) ->
        "has-text-danger has-text-weight-bold"

      other_month?(assigns) ->
        "has-text-grey"

      true ->
        "has-text-black-bis"
    end
  end

  defp invalid_date?(assigns) do
    Timex.to_date(assigns.day) not in assigns.dates
  end

  defp current_date?(assigns) do
    Map.take(assigns.day, [:year, :month, :day]) ==
      Map.take(assigns.current_date, [:year, :month, :day])
  end

  defp today?(assigns) do
    Map.take(assigns.day, [:year, :month, :day]) == Map.take(Timex.now(), [:year, :month, :day])
  end

  defp other_month?(assigns) do
    Map.take(assigns.day, [:year, :month]) != Map.take(assigns.cursor_date, [:year, :month])
  end
end
