defmodule ActivityPlanner.Factory do
  alias ActivityPlanner.Repo

  # Internal factory methods

  defp build(:company) do
    %ActivityPlanner.Companies.Company{
      name: "Name",
      description: "Description",
      address: "Address"
    }
  end

  defp build(:participant) do
    %ActivityPlanner.Participants.Participant{
      name: "Name",
      description: "Description",
      email: "email@email.com",
      phone: "12345678"
    }
  end

  defp build(:activity_participant) do
    %ActivityPlanner.Activities.ActivityParticipant{}
  end

  defp build(:activity_group) do
    %ActivityPlanner.Activities.ActivityGroup{
      name: "Name",
      description: "Description"
    }
  end

  defp build(:activity) do
    %ActivityPlanner.Activities.Activity{
      title: "Title",
      description: "Description",
      start_time: Timex.now(),
      end_time: Timex.shift(Timex.now(), days: 2)
    }
  end

  defp build(:notification_template) do
    %ActivityPlanner.Notifications.NotificationTemplate{
      title: "Title",
      template_content: "Content"
    }
  end

  defp build(:notification_schedule) do
    %ActivityPlanner.Notifications.NotificationSchedule{
      name: "Name",
      cron_expression: "* * * * *",
      medium: "sms",
      hours_window_offset: 0,
      hours_window_length: 24,
      enabled: true
    }
  end

  defp build(:sent_notification) do
    %ActivityPlanner.Notifications.SentNotification{
      sent_at: Timex.now(),
      status: "sent",
      medium: "sms",
      receiver: "receiver",
      actual_content: "content",
      actual_title: "title"
    }
  end

  # Public convenience API

  def build(factory_name, attributes) do
    factory_name |> build() |> struct!(attributes)
  end

  def insert!(factory_name, attributes \\ []) do
    factory_name |> build(attributes) |> Repo.insert!()
  end
end
