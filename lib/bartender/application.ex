defmodule Bartender.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      Bartender.Repo,
      Bartender.Consumer
    ]

    options = [strategy: :one_for_one, name: Bartender.Supervisor]
    Supervisor.start_link(children, options)
  end
end
