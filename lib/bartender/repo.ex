defmodule Bartender.Repo do
  use Ecto.Repo,
    otp_app: :bartender,
    adapter: Ecto.Adapters.Postgres
end
