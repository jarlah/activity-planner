defmodule ActivityPlanner.Repo.Migrations.CreateActivities do
  use Ecto.Migration

  def change do
    create table(:activities) do
      add :title, :string
      add :start_time, :utc_datetime
      add :end_time, :utc_datetime
      add :responsible_participant_id, :integer
      add :description, :text
      add :activity_group_id, references(:activity_groups, on_delete: :nothing)

      timestamps()
    end

    create index(:activities, [:activity_group_id])
  end
end
