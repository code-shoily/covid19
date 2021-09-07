defmodule Covid19.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Covid19.Repo,
      # Start the Telemetry supervisor
      Covid19Web.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Covid19.PubSub},
      # Start the Endpoint (http/https)
      Covid19Web.Endpoint
      # Start a worker by calling: Covid19.Worker.start_link(arg)
      # {Covid19.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Covid19.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    Covid19Web.Endpoint.config_change(changed, removed)
    :ok
  end
end
