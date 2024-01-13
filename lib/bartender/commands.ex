defmodule Bartender.Commands do
  alias Nostrum.Struct.Interaction
  alias Nostrum.Api
  alias Bartender.Commands

  @commands [
    Commands.Ping
  ]

  def commands() do
    @commands
  end

  def register() do
    guild_id = Application.fetch_env!(:bartender, :guild_id)

    @commands
    |> Enum.map(& &1.schema())
    |> Enum.each(&Api.create_guild_application_command(guild_id, &1))
  end

  def handle_interaction(%Interaction{data: %{name: "ping"}} = interaction) do
    Commands.Ping.handle(interaction)
  end
end
