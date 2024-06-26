defmodule Bartender.MixProject do
  use Mix.Project

  def project do
    [
      app: :bartender,
      version: "0.1.0",
      elixir: "~> 1.16",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Bartender.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:nostrum, "~> 0.9.0"},
      {:ecto_sql, "~> 3.0"},
      {:ecto_sqlite3, "~> 0.16"},
      # {:postgrex, ">= 0.0.0"},
      {:ok, "~> 2.3"},
      {:defconstant, "~> 1.0.0"},
      {:dialyxir, "~> 1.4", only: [:dev, :test], runtime: false},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false}
    ]
  end
end
