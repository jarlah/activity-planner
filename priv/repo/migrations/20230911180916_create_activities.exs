defmodule ActivityPlanner.Repo.Migrations.CreateActivities do
  use Ecto.Migration

  def change do
    create table(:activities) do
      add :title, :string
      add :start_time, :utc_datetime
      add :end_time, :utc_datetime
      add :responsible_participant_id, references(:participants, on_delete: :nothing)

      timestamps()
    end

    create index(:activities, [:responsible_participant_id])
  end
end
