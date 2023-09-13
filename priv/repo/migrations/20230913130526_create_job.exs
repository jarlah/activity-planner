defmodule ActivityPlanner.Repo.Migrations.CreateJob do
  use Ecto.Migration

  def change do
    create table(:job) do
      add :name, :string
      add :cron_expression, :string
      add :task_module, :string
      add :task_function, :string
      add :task_args, {:array, :string}

      timestamps()
    end
  end
end
