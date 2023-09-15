defmodule ActivityPlanner.Notifications.NotificationScheduleAdmin do
  def after_insert(_conn, schedule) do
    ActivityPlanner.JobManager.add_job(schedule)
  end

  def after_delete(_conn, schedule) do
    ActivityPlanner.JobManager.delete_job(schedule)
  end
end
