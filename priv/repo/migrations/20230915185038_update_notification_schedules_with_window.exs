defmodule ActivityPlanner.Repo.Migrations.UpdateNotificationSchedulesWithWindow do
  use Ecto.Migration

  def change do
    rename table(:notification_schedules), :days_offset, to: :days_window_offset

    alter table(:notification_schedules) do
      add :days_window_length, :integer
    end
  end
end
