defmodule ActivityPlanner.Factory do
  alias ActivityPlanner.Repo

  import Ecto.Changeset, only: [apply_changes: 1, put_assoc: 3]

  defp build(attributes, :company) do
    %ActivityPlanner.Companies.Company{
      name: "Default Company Name",
      description: "Default Description",
      address: "Default Address"
    }
    |> ActivityPlanner.Companies.Company.changeset(attributes)
  end

  defp build(attributes, :activity_group) do
    company = attributes |> Map.get_lazy(:company, fn -> insert!(:company) end)

    %ActivityPlanner.Activities.ActivityGroup{
      name: "Default Activity Group Name",
      description: "Default Description"
    }
    |> ActivityPlanner.Activities.ActivityGroup.changeset(attributes)
    |> put_assoc(:company, company)
  end

  defp build(attributes, :participant) do
    company = attributes |> Map.get_lazy(:company, fn -> insert!(:company) end)

    %ActivityPlanner.Participants.Participant{
      name: "Default Participant Name",
      description: "Default Description",
      email: "default@email.com",
      phone: "12345678"
    }
    |> ActivityPlanner.Participants.Participant.changeset(attributes)
    |> put_assoc(:company, company)
  end

  defp build(attributes, :activity_participant) do
    company = attributes |> Map.get_lazy(:company, fn -> insert!(:company) end)

    activity =
      attributes
      |> Map.get_lazy(:activity, fn ->
        insert!(:activity, company: company)
      end)

    participant =
      attributes
      |> Map.get_lazy(:participant, fn ->
        insert!(:participant, company_id: company.company_id)
      end)

    %ActivityPlanner.Activities.ActivityParticipant{}
    |> ActivityPlanner.Activities.ActivityParticipant.changeset(attributes)
    |> put_assoc(:company, company)
    |> put_assoc(:activity, activity)
    |> put_assoc(:participant, participant)
  end

  defp build(attributes, :activity) do
    now = DateTime.truncate(Timex.now(), :second)

    company = attributes |> Map.get_lazy(:company, fn -> insert!(:company) end)

    activity_group =
      attributes
      |> Map.get_lazy(:activity_group, fn ->
        insert!(:activity_group, company_id: company.company_id)
      end)

    responsible_participant =
      attributes
      |> Map.get_lazy(:responsible_participant, fn ->
        insert!(:participant, company_id: company.company_id)
      end)

    %ActivityPlanner.Activities.Activity{
      title: "Default Activity Title",
      description: "Default Activity Description",
      start_time: now,
      end_time: Timex.shift(now, days: 2)
    }
    |> ActivityPlanner.Activities.Activity.changeset(attributes)
    |> put_assoc(:company, company)
    |> put_assoc(:activity_group, activity_group)
    |> put_assoc(:responsible_participant, responsible_participant)
  end

  defp build(attributes, :notification_template) do
    company = attributes |> Map.get_lazy(:company, fn -> insert!(:company) end)

    %ActivityPlanner.Notifications.NotificationTemplate{
      title: "Default Notification Template Title",
      template_content: "Default Notification Template Content"
    }
    |> ActivityPlanner.Notifications.NotificationTemplate.changeset(attributes)
    |> put_assoc(:company, company)
  end

  defp build(attributes, :notification_schedule) do
    company = attributes |> Map.get_lazy(:company, fn -> insert!(:company) end)

    activity_group =
      attributes
      |> Map.get_lazy(:activity_group, fn ->
        insert!(:activity_group, company_id: company.company_id)
      end)

    notification_template =
      attributes
      |> Map.get_lazy(:template, fn ->
        insert!(:notification_template, company_id: company.company_id)
      end)

    %ActivityPlanner.Notifications.NotificationSchedule{
      name: "Name",
      cron_expression: "* * * * *",
      medium: "sms",
      hours_window_offset: 0,
      hours_window_length: 24,
      enabled: true
    }
    |> ActivityPlanner.Notifications.NotificationSchedule.changeset(attributes)
    |> put_assoc(:company, company)
    |> put_assoc(:activity_group, activity_group)
    |> put_assoc(:template, notification_template)
  end

  defp build(attributes, :sent_notification) do
    company = attributes |> Map.get_lazy(:company, fn -> insert!(:company) end)

    activity =
      attributes
      |> Map.get_lazy(:activity, fn ->
        insert!(:activity, company: company)
      end)

    %ActivityPlanner.Notifications.SentNotification{
      sent_at: Timex.now(),
      status: "sent",
      medium: "sms",
      receiver: "receiver",
      actual_content: "content",
      actual_title: "title"
    }
    |> ActivityPlanner.Notifications.SentNotification.changeset(attributes)
    |> put_assoc(:company, company)
    |> put_assoc(:activity, activity)
  end

  def insert!(factory_name, attributes \\ []) do
    Enum.into(attributes, %{})
    |> build(factory_name)
    |> apply_changes()
    |> Repo.insert!()
  end
end
