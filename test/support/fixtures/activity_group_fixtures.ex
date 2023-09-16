defmodule ActivityPlanner.ActivityGroupFixtures do
  def activity_group_fixture(attrs \\ %{}, company_id) do
    {:ok, activity_group} =
      attrs
      |> Enum.into(%{
        name: "some title",
        description: "some description",
        company_id: company_id
      })
      |> ActivityPlanner.Activities.create_activity_group()

      activity_group
  end
end
