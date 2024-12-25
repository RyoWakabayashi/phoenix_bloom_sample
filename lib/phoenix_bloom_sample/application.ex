defmodule PhoenixBloomSample.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      PhoenixBloomSampleWeb.Telemetry,
      {DNSCluster,
       query: Application.get_env(:phoenix_bloom_sample, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: PhoenixBloomSample.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: PhoenixBloomSample.Finch},
      # Start a worker by calling: PhoenixBloomSample.Worker.start_link(arg)
      # {PhoenixBloomSample.Worker, arg},
      # Start to serve requests, typically the last entry
      PhoenixBloomSampleWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: PhoenixBloomSample.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PhoenixBloomSampleWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
