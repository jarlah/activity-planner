defmodule ActivityPlanner.Notifications do
  import Swoosh.Email

  alias ActivityPlanner.Activities
  alias ActivityPlanner.Mailer
  alias ActivityPlanner.SMS
  alias Timex.Format.DateTime.Formatter

  def send_notifications do
    from_email = Application.fetch_env!(:activity_planner, ActivityPlanner.Mailer)[:from_email]

    activities = Activities.get_activities_for_the_next_two_days() |> ActivityPlanner.Repo.preload([:participants, :responsible_participant])

    Enum.each(activities, fn activity ->
      {:ok, formatted_time} = Formatter.format(activity.start_time, "%d-%m-%Y", :strftime)
      Enum.each(activity.participants ++ [activity.responsible_participant], fn participant ->
        {:ok, _} = send_email(participant.email, from_email, "Reminder for activity",  """
        ==============================

        Hi #{participant.name},

        This is a reminder for a planned activity at

        #{formatted_time}

        Hope we see you there :)

        Best regards,
        Activity planner

        ==============================
        """)
        {:ok, _} = SMS.send_sms(participant.phone, """
        Hi #{participant.name}. This is a reminder for a planned activity at #{formatted_time}. Hope we see you there :) Best regards, Activity planner
        """)
      end)
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
