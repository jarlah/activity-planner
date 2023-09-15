defmodule ActivityPlanner.Notifications do
  import Swoosh.Email

  alias ActivityPlanner.Mailer
  alias ActivityPlanner.SMS
  alias Timex.Format.DateTime.Formatter
  alias ActivityPlanner.Notifications.NotificationSchedule
  alias ActivityPlanner.Notifications.SentNotification
  alias ActivityPlanner.Repo

  def list_notification_schedules do
    ActivityPlanner.Repo.all(NotificationSchedule) |> preload_notiification_schedule()
  end

  def send_notifications_for_schedule(schedule_id) do
    schedule = ActivityPlanner.Repo.get!(NotificationSchedule, schedule_id) |> preload_notiification_schedule()
    schedule.activity_group.activities |> Enum.each(fn activity -> send_notifications(schedule.template, schedule.medium, activity) end)
  end

  defp send_notifications(template, :email, activity) do
    from_email = Application.fetch_env!(:activity_planner, ActivityPlanner.Mailer)[:from_email]
    (activity.participants ++ [activity.responsible_participant])
    |> Enum.each(fn participant ->
      content = render_template_for_activity(template.template_content, participant, activity)
      {:ok, _} = send_email(participant.email, from_email, "Reminder for activity", content)
      {:ok, _} = sent_notification("email", participant.email, content, activity.id)
    end)
  end

  defp send_notifications(template, :sms, activity) do
    (activity.participants ++ [activity.responsible_participant])
    |> Enum.each(fn participant ->
      content = render_template_for_activity(template.template_content, participant, activity)
      {:ok, _} = SMS.send_sms(participant.phone, content)
      {:ok, _} = sent_notification("sms", participant.phone, content, activity.id)
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

  defp sent_notification(medium, receiver, content, activity_id) do
    %SentNotification{
      sent_at: DateTime.truncate(DateTime.utc_now(), :second),
      medium: medium,
      receiver: receiver,
      status: "sent",
      actual_content: content,
      actual_title: "Reminder for activity",
      activity_id: activity_id
    }
    |> SentNotification.changeset(%{})
    |> Repo.insert()
  end

  defp render_template_for_activity(template, participant, activity) do
    Mustache.render(template, %{
      startDate: Formatter.format!(activity.start_time, "%d-%m-%Y", :strftime),
      startTime: Formatter.format!(activity.start_time, "%H:%m", :strftime),
      participant: participant |> Map.from_struct(),
      participants: activity.participants |> Enum.each(&Map.from_struct/1),
      responsibleParticipant: activity.responsible_participant |> Map.from_struct()
    })
  end

  defp preload_notiification_schedule(schedule) do
    schedule |> ActivityPlanner.Repo.preload([:template, activity_group: [activities: [:participants, :responsible_participant]]])
  end
end
