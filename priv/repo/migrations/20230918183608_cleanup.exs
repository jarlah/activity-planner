defmodule ActivityPlanner.Repo.Migrations.Cleanup do
  use Ecto.Migration

  def change do
    alter table(:activities) do
      modify :responsible_participant_id, references(:participants, on_delete: :nothing), null: false
    end
  end
end
