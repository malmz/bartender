defmodule Bartender.Actors do
  use Ash.Domain

  resources do
    resource Bartender.Actors.Player
  end
end
