defmodule ActivityPlanner.Repo.Migrations.CreateNotificationSchedules do
  use Ecto.Migration

  def change do
    drop table("notification_settings")

    create table(:notification_schedules) do
      add :name, :string
      add :medium, :notification_medium_enum
      add :cron_expression, :map
      add :activity_group_id, references(:activity_groups, on_delete: :delete_all)
      add :template_id, references(:notification_templates, on_delete: :delete_all)

      timestamps()
    end
  end
end
