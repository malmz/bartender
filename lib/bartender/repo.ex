defmodule Bartender.Repo do
  @moduledoc false
  use Ecto.Repo,
    otp_app: :bartender,
    adapter: Ecto.Adapters.Postgres
end
