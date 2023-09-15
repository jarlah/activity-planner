defmodule ActivityPlanner.Repo.Migrations.UpdateNotificationSchedules do
  use Ecto.Migration

  def change do
    alter table(:notification_schedules) do
      remove :activity_group_id
      add :activity_group_id, references(:activity_groups, on_delete: :nothing)
      remove :template_id
      add :template_id, references(:notification_templates, on_delete: :nothing)
    end
  end
end
