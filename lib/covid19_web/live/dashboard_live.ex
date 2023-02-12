defmodule Covid19Web.DashboardLive do
  use Covid19Web, :live_view

  alias Covid19.Queries

  def mount(_, _, socket) do
    assigns = %{
      summary: Queries.summary_by_dates(),
      dates: Queries.dates(:world),
      date_index: 0
    }

    {:ok, assign(socket, assigns)}
  end

  def render(assigns) do
    ~H"""
    Total Rows in World Summary is: <%= Enum.count(@summary) %>
    """
  end
end
