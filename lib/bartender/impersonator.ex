defmodule Bartender.Impersonator do
  @moduledoc false
  alias Nostrum.Cache.GuildCache
  alias Nostrum.Struct.User
  alias Nostrum.Cache.Me
  alias Nostrum.Struct.Guild
  alias Nostrum.Struct.Channel
  alias Nostrum.Api
  use GenServer
  use OK.Pipe

  @dialyzer {:nowarn_function, move_webhook: 2}

  defstruct application_id: nil, webhooks: %{}

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @impl true
  def init(_) do
    application_id = get_application_id()

    guild_ids =
      GuildCache.fold([], fn acc, %Guild{} = guild ->
        if not guild.unavailable, do: [guild.id | acc], else: acc
      end)

    webhooks =
      guild_ids
      |> Enum.map(fn guild_id ->
        find_guild_webhook(application_id, guild_id)
        ~> then(&{guild_id, &1})
      end)
      |> Enum.filter(&match?({:ok, _}, &1))
      |> Enum.map(fn {_, v} -> v end)
      |> Enum.into(%{})

    {:ok, %__MODULE__{application_id: application_id, webhooks: webhooks}}
  end

  @impl true
  def handle_cast({:send, guild_id, channel_id, name, msg}, state) do
    {webhook, new_state} = ensure_webhook(state, guild_id, channel_id)
    Api.execute_webhook(webhook.id, webhook.token, %{username: name, content: msg})
    {:noreply, new_state}
  end

  def handle_cast({:register, guild_id}, state) do
    {:ok, webhook} = find_guild_webhook(state.application_id, guild_id)
    {:noreply, put_webhook(state, guild_id, webhook)}
  end

  def handle_cast({:unregister, guild_id}, state) do
    webhooks = Map.delete(state.webhooks, guild_id)
    {:noreply, %{state | webhooks: webhooks}}
  end

  @spec send(
          guild_id :: Guild.id(),
          channel_id :: Channel.id(),
          name :: String.t(),
          msg :: String.t()
        ) :: :ok
  def send(guild_id, channel_id, name, msg) do
    GenServer.cast(__MODULE__, {:send, guild_id, channel_id, name, msg})
  end

  @spec add_guild(guild_id :: Guild.id()) :: :ok
  def add_guild(guild_id) do
    GenServer.cast(__MODULE__, {:register, guild_id})
  end

  @spec remove_guild(guild_id :: Guild.id()) :: :ok
  def remove_guild(guild_id) do
    GenServer.cast(__MODULE__, {:unregister, guild_id})
  end

  defp ensure_webhook(%__MODULE__{} = state, guild_id, channel_id) do
    channel_id = to_string(channel_id)

    case state.webhooks[guild_id] do
      nil ->
        {:ok, new_webhook} = Api.create_webhook(channel_id, %{name: "Impersonator", avatar: ""})
        {new_webhook, put_webhook(state, guild_id, new_webhook)}

      %{channel_id: ^channel_id} = webhook ->
        {webhook, state}

      webhook ->
        {:ok, new_webhook} =
          move_webhook(webhook, channel_id)

        {new_webhook, put_webhook(state, guild_id, new_webhook)}
    end
  end

  defp find_guild_webhook(application_id, guild_id) do
    Api.get_guild_webhooks(guild_id)
    ~> Enum.find(&(&1.application_id == application_id))
  end

  defp put_webhook(%__MODULE__{} = state, guild_id, webhook) do
    %{state | webhooks: Map.put(state.webhooks, guild_id, webhook)}
  end

  defp move_webhook(webhook, channel_id) do
    Api.modify_webhook(webhook.id, %{channel_id: channel_id})
  end

  defp get_application_id() do
    case Me.get() do
      nil ->
        {:ok, %{id: application_id}} = Api.get_application_information()
        application_id

      %User{id: application_id} ->
        application_id
    end
  end
end
