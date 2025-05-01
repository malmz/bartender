defmodule Bartender.Commands.Ping do
  @moduledoc false
  @behaviour Bartender.ApplicationCommand

  import Bitwise

  @impl true
  def name, do: "ping"

  @impl true
  def description, do: "Ping the bot"

  @impl true
  def handle(_interaction, _path, _options) do
    %{
      type: 4,
      data: %{content: "Ping Pong!", flags: 1 <<< 6}
    }
  end
end
