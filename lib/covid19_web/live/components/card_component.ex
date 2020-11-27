defmodule Covid19Web.CardComponent do
  use Surface.Component

  def render(assigns) do
    ~H"""
    <div class="card">
      <div class="card-content has-text-centered">
        <slot />
      </div>
    </div>
    """
  end
end
