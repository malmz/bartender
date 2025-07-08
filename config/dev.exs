import Config

config :bartender, Bartender.Repo,
  username: "postgres",
  password: "",
  hostname: "localhost",
  database: "bartender_dev",
  stacktrace: true,
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

config :logger, :console, format: "[$level] $message\n"
