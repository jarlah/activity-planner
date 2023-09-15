defmodule ActivityPlanner.Notifications.NotificationScheduleAdmin do
  def form_fields(_) do
    [
      name: nil,
      medium: %{choices: [{"E-mail", "email"}, {"SMS", "sms"}]},
      cron_expression: nil,
      activity_group_id: nil,
      template_id: nil,
      days_window_offset: nil,
      days_window_length: nil,
      enabled: nil
    ]
  end

  def index(_) do
    [
      name: nil,
      medium: nil,
      activity_group_id: nil,
      template_id: nil,
      days_window_offset: nil,
      days_window_length: nil,
      enabled: nil
    ]
  end

  def after_insert(_conn, schedule) do
    ActivityPlanner.JobManager.add_job(schedule)
  end

  def after_update(_conn, schedule) do
    ActivityPlanner.JobManager.add_job(schedule)
  end

  def after_delete(_conn, schedule) do
    ActivityPlanner.JobManager.delete_job(schedule)
  end

  defimpl Phoenix.HTML.Safe, for: Crontab.CronExpression do
    @spec to_iodata(Crontab.CronExpression.t()) :: String.t()
    def to_iodata(cron) do
      Phoenix.HTML.Safe.to_iodata(Crontab.CronExpression.Composer.compose(cron))
    end
  end
end
