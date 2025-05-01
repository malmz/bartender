import Config

if config_env() == :dev do
  import_config "secrets.exs"
end

config :nostrum,
  caches: %{
    presences: Nostrum.Cache.PresenceCache.NoOp
  },
  gateway_intents: [
    :guilds,
    :guild_webhooks,
    :guild_messages,
    :message_content
  ]

config :bartender, Bartender.Repo, database: "./data.db"

config :bartender,
  ecto_repos: [Bartender.Repo]

config :logger,
  level: :debug

config :logger, :console, metadata: [:guild, :channel]
