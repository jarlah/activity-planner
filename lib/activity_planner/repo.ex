defmodule ActivityPlanner.Repo do
  use Ecto.Repo,
    otp_app: :activity_planner,
    adapter: Ecto.Adapters.Postgres
end
