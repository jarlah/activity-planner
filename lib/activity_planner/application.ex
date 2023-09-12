defmodule ActivityPlanner.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    topologies = Application.get_env(:libcluster, :topologies) || []

    children = [
      # Start the Telemetry supervisor
      ActivityPlannerWeb.Telemetry,
      # Start the Ecto repository
      ActivityPlanner.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: ActivityPlanner.PubSub},
      # Start Finch
      {Finch, name: ActivityPlanner.Finch},
      # Start the Endpoint (http/https)
      ActivityPlannerWeb.Endpoint,
      # Start a worker by calling: ActivityPlanner.Worker.start_link(arg)
      # {ActivityPlanner.Worker, arg}
      {Cluster.Supervisor, [topologies, [name: ActivityPlanner.ClusterSupervisor]]},
      {Highlander, ActivityPlanner.Scheduler},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ActivityPlanner.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ActivityPlannerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
