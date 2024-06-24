import Config

if config_env() == :dev do
  import_config "secrets.exs"
end

config :nostrum,
  gateway_intents: [
    :guilds
  ]

config :bartender, Bartender.Repo, database: "./data.db"

config :bartender,
  ecto_repos: [Bartender.Repo]

config :logger, :default_handler, level: :debug
config :logger, :default_formatter, metadata: [:shard, :guild, :channel]
