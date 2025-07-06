# Used by "mix format"
[
  inputs: ["{mix,.formatter}.exs", "{config,lib,test}/**/*.{ex,exs}", "priv/*/seeds.exs"],
  import_deps: [:ecto, :ecto_sql, :defconstant, :ash, :reactor],
  plugins: [Spark.Formatter],
  subdirectories: ["priv/*/migrations"]
]
