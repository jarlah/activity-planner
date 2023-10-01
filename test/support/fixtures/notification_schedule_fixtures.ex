defmodule ActivityPlanner.NotificationScheduleFixtures do
  import ActivityPlanner.CompanyFixtures
  import ActivityPlanner.ActivityGroupFixtures
  import ActivityPlanner.NotificationTemplateFixtures

  @doc """
  Generate a activity.
  """
  def notification_schedule_fixture(attrs \\ %{}, opts \\ []) do
    company_id = opts |> Keyword.get_lazy(:company_id, fn -> company_fixture().company_id end)

    template_id =
      attrs
      |> Map.get_lazy(:template_id, fn ->
        notification_template_fixture(%{}, company_id: company_id).id
      end)

    activity_group_id =
      attrs
      |> Map.get_lazy(:activity_group_id, fn ->
        activity_group_fixture(%{}, company_id: company_id).id
      end)

    {:ok, activity} =
      attrs
      |> Enum.into(%{
        name: "some name",
        medium: "sms",
        cron_expression: "* * * * *",
        hours_window_offset: 0,
        hours_window_length: 24,
        enabled: true,
        template_id: template_id,
        activity_group_id: activity_group_id
      })
      |> ActivityPlanner.Notifications.create_notification_schedule(company_id: company_id)

    activity
  end
end
