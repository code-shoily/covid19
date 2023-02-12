# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :covid19,
  ecto_repos: [Covid19.Repo]

# Configures the endpoint
config :covid19, Covid19Web.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "z+p8BXgrWgbt/jqTJEkO/NVEyxm55g+Z9k8v6KsJM56dqn1/lDqe9yVs6Q1jg5sH",
  render_errors: [
    formats: [html: Covid19Web.ErrorHTML, json: Covid19Web.ErrorJSON],
    layout: false
  ],
  pubsub_server: Covid19.PubSub,
  live_view: [signing_salt: "vOqYjEvR"]

# Nebulex
config :covid19, Covid19.PartitionedCache,
  primary: [
    gc_interval: :timer.hours(12)
  ]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :covid19, Covid19.Mailer, adapter: Swoosh.Adapters.Local

# Swoosh API client is needed for adapters other than SMTP.
config :swoosh, :api_client, false

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.14.41",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Dart SASS
config :dart_sass,
  version: "1.54.5",
  default: [
    args: ~w(css/app.scss ../priv/static/assets/app.css),
    cd: Path.expand("../assets", __DIR__)
  ]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
