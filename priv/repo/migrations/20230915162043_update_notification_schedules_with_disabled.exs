defmodule ActivityPlanner.Repo.Migrations.UpdateNotificationSchedulesWithDisabled do
  use Ecto.Migration

  def change do
    alter table(:notification_schedules) do
      add :enabled, :boolean, default: true
    end
  end
end
