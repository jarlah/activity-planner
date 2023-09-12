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
    password_length = 12
    admin_email = "admin@example.com"
    case ActivityPlanner.Accounts.get_user_by_email(admin_email) do
      nil ->
        # Generate a strong random password
        random_bytes = :crypto.strong_rand_bytes(password_length)
        strong_password = Base.encode64(random_bytes) |> String.slice(0, password_length)

        IO.puts("Generated admin password: #{strong_password}")

        user_params = %{
          email: admin_email,
          password: strong_password,
          is_admin: true
        }

        {:ok, _user} = ActivityPlanner.Accounts.register_user(user_params)

      _ ->
        IO.puts("Admin user already exists, skipping.")
    end
  end
end
