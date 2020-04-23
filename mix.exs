defmodule FileSize.Ecto.MixProject do
  use Mix.Project

  def project do
    [
      app: :file_size_ecto,
      version: "2.0.1",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      description: description(),
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test,
        "coveralls.travis": :test
      ],
      dialyzer: [plt_add_apps: [:ex_unit, :mix]],
      package: package(),
      elixirc_paths: elixirc_paths(Mix.env()),

      # Docs
      name: "File Size for Ecto",
      source_url: "https://github.com/tlux/file_size_ecto",
      docs: [
        main: "readme",
        extras: ["README.md"],
        groups_for_modules: [
          "Normalized Types": [
            FileSize.Ecto.Bit,
            FileSize.Ecto.Byte
          ],
          "Types with Units": [
            FileSize.Ecto.BitWithUnit,
            FileSize.Ecto.ByteWithUnit
          ]
        ]
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:credo, "~> 1.0.5", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0.0", only: [:dev, :test], runtime: false},
      {:ecto, "~> 3.0"},
      {:ex_doc, "~> 0.20.2", only: :dev, runtime: false},
      {:excoveralls, "~> 0.11.0", only: :test},
      {:file_size, ">= 2.0.0 and < 4.0.0"}
    ]
  end

  defp description do
    "Provides types for file sizes that you can use in your Ecto schemata."
  end

  defp package do
    [
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/tlux/file_size_ecto"
      }
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]
end
