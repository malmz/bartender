defmodule Bartender.Actors.Player do
  use Ash.Resource,
    domain: Bartender.Actors,
    data_layer: Ash.DataLayer.Ets

  actions do
    defaults [:read]

    create :create
  end

  attributes do
    uuid_primary_key :id

    attribute :discord_id, :integer
  end
end
