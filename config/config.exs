import Config

config :nostrum,
  caches: %{
    presences: Nostrum.Cache.PresenceCache.NoOp
  },
  gateway_intents: [
    :guilds,
    :guild_webhooks,
    :guild_messages,
    :message_content
  ],
  ffmpeg: nil

config :bartender,
  ash_domains: [Bartender.Actors]

config :bartender,
  ecto_repos: [Bartender.Repo],
  generators: [timestamp_type: :utc_datetime]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:guild, :channel]

import_config "#{config_env()}.exs"
