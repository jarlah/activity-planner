defmodule ActivityPlanner.Release do
  @moduledoc """
  Used for executing DB release tasks when run in production without Mix
  installed.
  """
  @app :activity_planner

  def migrate do
    load_app()

    for repo <- repos() do
      {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :up, all: true))
    end
  end

  def rollback(repo, version) do
    load_app()
    {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :down, to: version))
  end

  defp repos do
    Application.fetch_env!(@app, :ecto_repos)
  end

  defp load_app do
    Application.load(@app)
  end

  def seed_admin do
    IO.puts("Loading your_app..")
    # Load the code for your_app, but don't start it
    :ok = Application.load(@app)

    IO.puts("Starting dependencies..")
    # Start apps necessary for executing migrations
    {:ok, _} = Application.ensure_all_started(:logger)
    {:ok, _} = Application.ensure_all_started(:ecto_sql)

    IO.puts("Fetching ecto repos..")
    repos = Application.fetch_env!(@app, :ecto_repos)

    # Run the seed script
    Enum.each(repos, &create_admin_account_for/1)
  end

  defp create_admin_account_for(repo) do
    IO.puts("Creating admin account for #{inspect(repo)}..")
    ActivityPlanner.Accounts.create_admin_account("admin@example.com", 12)
  end
end
