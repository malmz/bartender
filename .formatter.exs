# Used by "mix format"
[
  inputs: ["{mix,.formatter}.exs", "{config,lib,test}/**/*.{ex,exs}", "priv/*/seeds.exs"],
  import_deps: [:ecto, :ecto_sql, :defconstant],
  subdirectories: ["priv/*/migrations"]
]
