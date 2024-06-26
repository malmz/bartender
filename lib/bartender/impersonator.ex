defmodule Bartender.Impersonator do
  @moduledoc false
  alias Nostrum.Struct.Channel
  alias Nostrum.Api
  use GenServer
  use OK.Pipe

  @dialyzer {:nowarn_function, move_webhook: 2}
  @dialyzer {:nowarn_function, handle_cast: 2}

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  @impl true
  def init(_) do
    with {:ok, %{id: application_id}} <- Api.get_application_information(),
         {:ok, webhooks} <- Api.get_guild_webhooks(guild_id()) do
      Enum.find(webhooks, fn %{application_id: ^application_id} -> true end)
      |> case do
        nil ->
          create_webhook()

        webhook ->
          {:ok, webhook}
      end
    else
      {:error, reason} ->
        {:stop, reason, nil}
    end
  end

  @impl true
  def handle_cast({:send, channel_id, msg}, webhook) do
    with {:ok, webhook} <- move_webhook(channel_id, webhook),
         :ok <- Api.execute_webhook(webhook.id, webhook.token, %{content: msg}) do
      {:noreply, webhook}
    else
      {:error, reason} ->
        {:stop, reason, webhook}
    end
  end

  @spec send(channel_id :: Channel.id(), msg :: String.t()) :: :ok
  def send(channel_id, msg) do
    GenServer.cast(__MODULE__, {:send, channel_id, msg})
  end

  defp create_webhook() do
    get_first_channel()
    ~>> create_webhook()
  end

  defp create_webhook(channel_id) do
    Api.create_webhook(channel_id, %{name: "Impersonator", avatar: ""})
  end

  defp get_first_channel() do
    guild_id()
    |> Api.get_guild_channels()
    ~> List.first()
  end

  defp move_webhook(channel_id, webhook) do
    body = %{channel_id: channel_id}
    Api.modify_webhook(webhook.id, body)
  end

  defp guild_id do
    Application.fetch_env!(:bartender, :guild_id)
  end
end
