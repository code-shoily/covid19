defmodule Covid19Web.DetailLive do
  @moduledoc false

  use Covid19Web, :surface

  alias Covid19.Queries

  def mount(%{"country_or_region" => country_or_region}, _session, socket) do
    dates = tl(Queries.processed_dates_for_country(country_or_region))
    summary = Queries.country_summary(country_or_region)
    index = -1

    assigns = %{
      country_or_region: country_or_region,
      country_summary: summary,
      dates: dates,
      selected_index: index,
      summary_data: summary_data(summary, dates, index),
      admin_data: admin_data(country_or_region, dates, index)
    }

    {:ok, assign(socket, assigns)}
  end

  def handle_event("pick-date", %{"date" => date}, socket) do
    date = Timex.parse!(date, "{YYYY}-{0M}-{D}") |> Timex.to_date()
    index = Enum.find_index(socket.assigns.dates, &(&1 == date))
    socket = assign(socket, :selected_index, index)

    %{
      assigns: %{
        country_or_region: country_or_region,
        country_summary: data,
        dates: dates,
        selected_index: index
      }
    } = socket

    assigns = %{
      summary_data: summary_data(data, dates, index),
      admin_data: admin_data(country_or_region, dates, index)
    }

    {:noreply, assign(socket, assigns)}
  end

  def handle_event(direction, _, socket) do
    socket = update(socket, :selected_index, next_index(direction))

    %{
      assigns: %{
        country_or_region: country_or_region,
        country_summary: data,
        dates: dates,
        selected_index: index
      }
    } = socket

    assigns = %{
      summary_data: summary_data(data, dates, index),
      admin_data: admin_data(country_or_region, dates, index)
    }

    {:noreply, assign(socket, assigns)}
  end

  defp next_index("oldest"), do: fn _ -> 0 end
  defp next_index("older"), do: fn idx -> idx - 1 end
  defp next_index("newest"), do: fn _ -> -1 end
  defp next_index("newer"), do: fn idx -> idx + 1 end

  defp summary_data(data, dates, index) do
    summary = Enum.group_by(data, & &1.date)
    hd(summary[Enum.at(dates, index)])
  end

  defp admin_data(country_or_region, dates, index) do
    Queries.admin_summary(country_or_region, Enum.at(dates, index))
  end
end
