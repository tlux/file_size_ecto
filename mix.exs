defmodule FileSizeEcto.MixProject do
  use Mix.Project

  def project do
    [
      app: :file_size_ecto,
      version: "1.0.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
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
      {:ecto, "~> 3.0"},
      {:ex_doc, "~> 0.20.2", only: :dev, runtime: false},
      {:excoveralls, "~> 0.11.0", only: :test},
      {:file_size, "~> 1.2"}
    ]
  end
end
