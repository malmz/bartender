defmodule Bartender.Utils do
  @moduledoc false
  alias Nostrum.Api
  alias Nostrum.Struct.Guild.Role
  alias Ecto.Changeset

  def format_error(changeset) do
    changeset
    |> Changeset.traverse_errors(fn {msg, opts} ->
      Regex.replace(~r"%{(\w+)}", msg, fn _, key ->
        opts |> Keyword.get(String.to_existing_atom(key), key) |> to_string()
      end)
    end)
    |> Enum.map_join("\n", fn {key, message} ->
      "#{key} #{message}"
    end)
  end

  def create_commands_map(commands) do
    Code.ensure_all_loaded!(commands)

    commands
    |> Enum.map(&{&1.name(), &1})
    |> Enum.into(%{})
  end

  def get_role_id_by_name(guild_id, name) do
    Api.get_guild_roles!(guild_id)
    |> Enum.find(fn role -> role.name == name end)
    |> then(fn %Role{id: id} -> id end)
  end
end
