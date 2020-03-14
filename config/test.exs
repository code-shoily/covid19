use Mix.Config

# Configure your database
config :covid19, Covid19.Repo,
  username: "postgres",
  password: "postgres",
  database: "covid19_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :covid19, Covid19Web.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
