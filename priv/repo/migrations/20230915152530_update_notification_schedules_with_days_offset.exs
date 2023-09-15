defmodule ActivityPlanner.Repo.Migrations.UpdateNotificationSchedulesWithDaysOffset do
  use Ecto.Migration

  def change do
    alter table(:notification_schedules) do
      add :days_offset, :integer
    end
  end
end
