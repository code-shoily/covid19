defmodule Covid19.MixProject do
  use Mix.Project

  def project do
    [
      app: :covid19,
      version: "0.2.0",
      elixir: "~> 1.14",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ]
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Covid19.Application, []},
      extra_applications: [:logger, :runtime_tools, :os_mon]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      # DB
      {:ecto_sql, "~> 3.7"},
      {:postgrex, ">= 0.0.0"},
      {:ecto_psql_extras, "~> 0.6"},
      # Web
      {:gettext, "~> 0.18"},
      {:jason, "~> 1.2"},
      {:finch, "~> 0.13"},
      # Phoenix and friends
      {:phoenix, "~> 1.7.0-rc.2", override: true},
      {:phoenix_ecto, "~> 4.4"},
      {:phoenix_html, "~> 3.2"},
      {:phoenix_live_reload, "~> 1.3", only: :dev},
      {:phoenix_live_view, "~> 0.18"},
      {:phoenix_live_dashboard, "~> 0.7.2"},
      {:swoosh, "~> 1.5"},
      {:esbuild, "~> 0.5", runtime: Mix.env() == :dev},
      {:plug_cowboy, "~> 2.5"},
      {:dart_sass, "~> 0.5", runtime: Mix.env() == :dev},
      # Scaping
      {:floki, ">= 0.31.0", only: :test},
      {:nimble_csv, "~> 1.2"},
      # Caching and Telemetry
      {:nebulex, "~> 2.4"},
      {:shards, "~> 1.0"},
      {:decorator, "~> 1.4"},
      {:telemetry, "~> 1.0"},
      {:telemetry_metrics, "~> 0.6"},
      {:telemetry_poller, "~> 1.0"},
      # Helpers
      {:countries, "~> 1.6"},
      {:timex, "~> 3.7"},
      # Dev and Testing
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false},
      {:stream_data, "~> 0.5", only: [:dev, :test]},
      {:ex_machina, "~> 2.7"},
      {:excoveralls, "~> 0.14", only: :test}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get", "ecto.setup", "assets.setup"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"],
      "assets.setup": ["esbuild.install --if-missing", "sass.install --if-missing"],
      "assets.deploy": [
        "esbuild default --minify",
        "sass default --no-source-map --style=compressed",
        "phx.digest"
      ]
    ]
  end
end
