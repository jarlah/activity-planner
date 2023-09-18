defmodule ActivityPlanner.Repo.Migrations.AddUserToParticipant do
  use Ecto.Migration

  def change do
    alter table(:participants) do
      add :user_id, references(:users, on_delete: :nothing), null: true
    end

    create unique_index(:participants, [:phone])
    create unique_index(:participants, [:email])
  end
end
