defmodule ActivityPlanner.Factory do
  alias ActivityPlanner.Repo
  import Ecto.Changeset, only: [apply_changes: 1]

  defp build(attributes, :company) do
    %ActivityPlanner.Companies.Company{
      name: "Default Company Name",
      description: "Default Description",
      address: "Default Address"
    }
    |> ActivityPlanner.Companies.Company.changeset(attributes)
  end

  defp build(attributes, :activity_group) do
    %ActivityPlanner.Activities.ActivityGroup{
      name: "Default Company Name",
      description: "Default Description"
    }
    |> ActivityPlanner.Activities.ActivityGroup.changeset(attributes,
      company_id: attributes.company_id
    )
  end

  defp build(attributes, :participant) do
    %ActivityPlanner.Participants.Participant{
      name: "Default Participant Name",
      description: "Default Description",
      email: "default@email.com",
      phone: "12345678"
    }
    |> ActivityPlanner.Participants.Participant.changeset(attributes,
      company_id: attributes.company_id
    )
  end

  defp build(attributes, :activity_participant) do
    %ActivityPlanner.Activities.ActivityParticipant{}
    |> ActivityPlanner.Activities.ActivityParticipant.changeset(attributes,
      company_id: attributes.company_id
    )
  end

  defp build(attributes, :activity) do
    %ActivityPlanner.Activities.Activity{
      title: "Title",
      description: "Description",
      start_time: Timex.now(),
      end_time: Timex.shift(Timex.now(), days: 2)
    }
    |> ActivityPlanner.Activities.Activity.changeset(attributes,
      company_id: attributes.company_id
    )
  end

  defp build(attributes, :notification_template) do
    %ActivityPlanner.Notifications.NotificationTemplate{
      title: "Title",
      template_content: "Content"
    }
    |> ActivityPlanner.Notifications.NotificationTemplate.changeset(attributes,
      company_id: attributes.company_id
    )
  end

  defp build(attributes, :notification_schedule) do
    %ActivityPlanner.Notifications.NotificationSchedule{
      name: "Name",
      cron_expression: "* * * * *",
      medium: "sms",
      hours_window_offset: 0,
      hours_window_length: 24,
      enabled: true
    }
    |> ActivityPlanner.Notifications.NotificationSchedule.changeset(attributes,
      company_id: attributes.company_id
    )
  end

  defp build(attributes, :sent_notification) do
    %ActivityPlanner.Notifications.SentNotification{
      sent_at: Timex.now(),
      status: "sent",
      medium: "sms",
      receiver: "receiver",
      actual_content: "content",
      actual_title: "title"
    }
    |> ActivityPlanner.Notifications.SentNotification.changeset(attributes,
      company_id: attributes.company_id
    )
  end

  def insert!(factory_name, attributes \\ []) do
    Enum.into(attributes, %{})
    |> build(factory_name)
    |> apply_changes()
    |> Repo.insert!()
  end
end
