defmodule ActivityPlanner.Notifications.NotificationScheduleAdmin do
  def form_fields(_) do
    [
      name: nil,
      medium: %{choices: [{"E-mail", "email"}, {"SMS", "sms"}]},
      cron_expression: %{choices: [{"Every minute", "* * * * *"}, {"Every hour", "0 * * * *"}, {"Every day", "0 0 * * *"}]},
      activity_group_id: nil,
      template_id: nil
    ]
  end

  def after_insert(_conn, schedule) do
    ActivityPlanner.JobManager.add_job(schedule |> ActivityPlanner.Notifications.preload_notiification_schedule())
  end

  def after_delete(_conn, schedule) do
    ActivityPlanner.JobManager.delete_job(schedule)
  end
end
