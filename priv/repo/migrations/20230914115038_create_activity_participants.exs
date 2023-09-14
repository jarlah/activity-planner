defmodule ActivityPlanner.Repo.Migrations.CreateActivityParticipants do
  use Ecto.Migration

  def change do
    create table(:activity_participants) do
      add :activity_id, references(:activities, on_delete: :nothing)
      add :participant_id, references(:participants, on_delete: :nothing)

      timestamps()
    end

    create index(:activity_participants, [:activity_id])
    create index(:activity_participants, [:participant_id])
  end
end
