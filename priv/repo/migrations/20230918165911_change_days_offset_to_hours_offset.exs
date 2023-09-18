defmodule ActivityPlanner.Repo.Migrations.ChangeDaysOffsetToHoursOffset do
  use Ecto.Migration

  def change do
    rename table(:notification_schedules), :days_window_offset, to: :hours_window_offset
    rename table(:notification_schedules), :days_window_length, to: :hours_window_length
  end
end
