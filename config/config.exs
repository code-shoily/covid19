# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :covid19,
  ecto_repos: [Covid19.Repo]

# Configures the endpoint
config :covid19, Covid19Web.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "S0MsJF4QErZU6wIFo090Z234cWG1Vz+Bara29Taiq0vE20fqCuqbqN3ROOLaNYaQ",
  render_errors: [view: Covid19Web.ErrorView, accepts: ~w(html json)],
  pubsub_server: Covid19.PubSub,
  live_view: [
    signing_salt: "ZDn`#z`=[ikOcWB"
  ]

config :covid19, :data_source,
  daily_dir: "data/covid19/csse_covid_19_data/csse_covid_19_daily_reports",
  daily_dir_us: "data/covid19/csse_covid_19_data/csse_covid_19_daily_reports_us"

config :covid19, Covid19.Cache,
  gc_interval: 86_400

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
