defmodule ActivityPlanner.NotificationTemplateFixtures do
  import ActivityPlanner.CompanyFixtures

  @doc """
  Generate a activity.
  """
  def notification_template_fixture(attrs \\ %{}, opts \\ []) do
    company_id = opts |> Keyword.get_lazy(:company_id, fn -> company_fixture().company_id end)

    {:ok, activity} =
      attrs
      |> Enum.into(%{
        title: "some title",
        template_content: "some content"
      })
      |> ActivityPlanner.Notifications.create_notification_template(company_id: company_id)

    activity
  end
end
