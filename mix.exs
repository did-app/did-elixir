defmodule Kno.MixProject do
  use Mix.Project

  def project do
    [
      app: :kno,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:plug, "~> 1.8", optional: true},
      {:phoenix_html, "~> 2.13", optional: true}
    ]
  end
end
