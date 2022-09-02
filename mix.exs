defmodule NBP.MixProject do
  use Mix.Project

  def project do
    [
      app: :nbp,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps(),

      description: description(),
      deps: deps(),
      package: package(),
      source_url: "https://github.com/mspanc/elixir-nbp",
    ]
  end

  def application do
    [
      extra_applications: [:logger, :crypto, :xmerl]
    ]
  end

  defp deps do
    [
      {:decimal, "~> 2.0"},
      {:tesla, "~> 1.4"},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
    ]
  end

  defp description do
    "Implementation of the NBP (Narodowy Bank Polski/National Bank of Poland) API."
  end

  defp package do
    [
      maintainers: ["Marcin Lewandowski"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/mspanc/elixir-nbp"}
    ]
  end
end
