defmodule Kno.MixProject do
  use Mix.Project

  def project do
    [
      app: :kno,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package(),
      source_url: "https://github.com/trykno/kno-elixir",
      homepage_url: "https://trykno.com"
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:jason, "~> 1.0"},
      {:plug, "~> 1.8", optional: true},
      {:phoenix_html, "~> 2.13", optional: true},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end

  defp description do
    """
    This simplest way to add passwordless authentication to your application.
    """
  end

  defp package do
    [
      maintainers: ["Peter Saxton"],
      licenses: ["Apache 2.0"],
      links: %{
        "GitHub" => "https://github.com/trykno/kno-elixir",
        "Homepage" => "https://trykno.com"
      }
    ]
  end
end
