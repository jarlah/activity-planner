defmodule ActivityPlanner.Notifications do
  import Swoosh.Email

  alias ActivityPlanner.Notifications.NotificationTemplate
  alias ActivityPlanner.Mailer
  alias ActivityPlanner.SMS
  alias Timex.Format.DateTime.Formatter
  alias ActivityPlanner.Notifications.NotificationSchedule
  alias ActivityPlanner.Notifications.SentNotification
  alias ActivityPlanner.Repo

  def list_notification_schedules(opts \\ []) do
    ActivityPlanner.Repo.all(NotificationSchedule, opts)
  end

  def list_notification_templates(opts \\ []) do
    ActivityPlanner.Repo.all(NotificationTemplate, opts)
  end

  def get_notification_template!(id), do: Repo.get!(NotificationTemplate, id)

  def create_notification_template(attrs \\ %{}) do
    %NotificationTemplate{company_id: Repo.get_company_id()}
    |> NotificationTemplate.changeset(attrs)
    |> IO.inspect()
    |> Repo.insert()
  end

  def update_notification_template(%NotificationTemplate{} = participant, attrs) do
    participant
    |> NotificationTemplate.changeset(attrs)
    |> Repo.update()
  end

  def delete_notification_template(%NotificationTemplate{} = participant) do
    Repo.delete(participant)
  end

  def change_notification_template(%NotificationTemplate{} = participant, attrs \\ %{}) do
    NotificationTemplate.changeset(participant, attrs)
  end

  def send_notifications_for_schedule(schedule_id) do
    case ActivityPlanner.NotificationSchedules.get_notification_schedules(
           schedule_id,
           Timex.now()
         ) do
      nil ->
        IO.puts("No matching schedule with activities found")

      schedule ->
        schedule.activity_group.activities
        |> Enum.each(fn activity ->
          send_notifications(schedule.template, schedule.medium, activity)
        end)
    end
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
      |> html_body(body)

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
      company: activity.activity_group.company |> Map.from_struct(),
      activityGroup: activity.activity_group |> Map.from_struct(),
      startDate: Formatter.format!(activity.start_time, "%d-%m-%Y", :strftime),
      startTime: Formatter.format!(activity.start_time, "%H:%M %Z", :strftime),
      participant: participant |> Map.from_struct(),
      participants: activity.participants |> Enum.map(&Map.from_struct/1),
      responsibleParticipant: activity.responsible_participant |> Map.from_struct()
    })
  end
end
