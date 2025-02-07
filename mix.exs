defmodule CheckoutSystem.MixProject do
  use Mix.Project

  def project do
    [
      app: :checkout_system,
      version: "0.1.0",
      elixir: "~> 1.17",
      start_permanent: Mix.env() == :prod,
      deps: deps()
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
      {:ecto, "~> 3.12.4"},

      #  only for test
      {:mix_test_interactive, "~> 4.1.1", only: :dev, runtime: false},

      # only dev and tests
      {:credo, "~> 1.7.10", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.4.4", only: :dev, runtime: false}
    ]
  end
end
