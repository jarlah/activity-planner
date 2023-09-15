defmodule ActivityPlanner.Repo.Migrations.UpdateNotificationSchedulesAgain do
  use Ecto.Migration

  def change do
    execute "delete from notification_schedules"
  end
end
