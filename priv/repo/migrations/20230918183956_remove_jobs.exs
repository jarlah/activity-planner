defmodule ActivityPlanner.Repo.Migrations.RemoveJobs do
  use Ecto.Migration

  def change do
    drop table(:job)
  end
end
