defmodule Covid19Web.CountryInfoComponent do
  use Covid19Web, :live_component

  defp fmt(%Date{} = date) do
    Timex.format!(date, "%b %d, %Y", :strftime)
  end

  def render(assigns) do
    ~L"""
    <div class="card">
      <div class="card-content has-text-centered">
        <p class="title is-6">
          <%= fmt(@date) %>
        </p>
        <p class="title is-3">
          <%= @country[:name] %>
        </p>
        <p class="subtitle">
          <%= @country[:continent] %>
        </p>
        <p>
          <a href="/">Back to World Data</a>
        </p>
      </div>
    </div>
    """
  end
end
