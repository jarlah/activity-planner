defmodule ActivityPlanner.Repo do
  use AshPostgres.Repo, otp_app: :activity_planner

  def installed_extensions do
    ["uuid-ossp", "citext"]
  end
end
