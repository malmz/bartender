defmodule Bartender.Utils do
  alias Ecto.Changeset

  def format_error(changeset) do
    changeset
    |> Changeset.traverse_errors(fn {msg, opts} ->
      Regex.replace(~r"%{(\w+)}", msg, fn _, key ->
        opts |> Keyword.get(String.to_existing_atom(key), key) |> to_string()
      end)
    end)
    |> Enum.map(fn {key, message} ->
      "#{key} #{message}"
    end)
    |> Enum.join("\n")
  end

  def create_commands_map(commands) do
    Code.ensure_all_loaded!(commands)

    commands
    |> Enum.map(&{&1.name(), &1})
    |> Enum.into(%{})
  end
end
