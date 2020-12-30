defmodule MapSchema.MixProject do
  @moduledoc false
  use Mix.Project

  def project do
    [
      app: :map_schema,
      version: "0.3.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      deps: deps(),
      name: "map_schema",
      source_url: "https://github.com/haskric/map_schema",
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [coveralls: :test, "coveralls.detail": :test, "coveralls.post": :test, "coveralls.html": :test],
      docs: docs()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  def docs do
    [
      main: "readme",
      extras: [
        "README.md",
        "EXAMPLES.md",
        "TYPES.md"
      ]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # Json encoder
      {:jason, "~> 1.2"},

      # mix docs
      {:earmark, "~> 1.2", only: :dev},
      {:ex_doc, "~> 0.19", only: :dev},

      ## MIX_ENV=test mix coveralls.html
      {:excoveralls, "~> 0.10", only: :test},

      ## mix credo
      {:credo, "~> 1.5", only: [:dev, :test], runtime: false}
    ]
  end

  defp description do
    "Simple, agile, map schema in elixir with type checking, custom types with casting and validation and with json encoding"
  end

  defp package do
    [
      files: [
        "lib",
        "LICENSE",
        "mix.exs",
        "README.md"
      ],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/haskric/map_schema"}
    ]
  end

end
