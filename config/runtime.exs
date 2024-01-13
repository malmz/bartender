import Config

if config_env() == :prod do
  config :nostrum,
    token: System.get_env("DISCORD_TOKEN") || raise("DISCORD_TOKEN not set")
end
