defmodule ActivityPlanner.Notifications do
  import Swoosh.Email

  alias ActivityPlanner.Mailer
  alias ActivityPlanner.SMS
  alias Timex.Format.DateTime.Formatter
  alias ActivityPlanner.Notifications.NotificationSchedule

  def list_notification_schedules do
    ActivityPlanner.Repo.all(NotificationSchedule) |> ActivityPlanner.Repo.preload([:template, activity_group: [:activities]])
  end

  def send_notifications_for_schedule(schedule_id) do
    schedule = ActivityPlanner.Repo.get!(NotificationSchedule, schedule_id) |> ActivityPlanner.Repo.preload([:template, activity_group: [activities: [:participants, :responsible_participant]]])
    schedule.activity_group.activities |> Enum.each(fn activity -> send_notifications(schedule.template, schedule.medium, activity) end)
  end

  defp send_notifications(template, :email, activity) do
    from_email = Application.fetch_env!(:activity_planner, ActivityPlanner.Mailer)[:from_email]
    {:ok, _formatted_time} = Formatter.format(activity.start_time, "%d-%m-%Y", :strftime)
    (activity.participants ++ [activity.responsible_participant])
    |> Enum.each(fn participant ->
      {:ok, _} = send_email(participant.email, from_email, "Reminder for activity", template.template_content)
    end)
  end

  defp send_notifications(template, :sms, activity) do
    {:ok, _formatted_time} = Formatter.format(activity.start_time, "%d-%m-%Y", :strftime)
    (activity.participants ++ [activity.responsible_participant])
    |> Enum.each(fn participant ->
      {:ok, _} = SMS.send_sms(participant.phone, template.template_content)
    end)
  end

  defp send_email(recipient, sender, subject, body) do
    email =
      new()
      |> to(recipient)
      |> from(sender)
      |> subject(subject)
      |> text_body(body)

    with {:ok, _metadata} <- Mailer.deliver(email) do
      {:ok, email}
    end
  end
end
