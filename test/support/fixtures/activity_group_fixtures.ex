defmodule ActivityPlanner.ActivityGroupFixtures do
  def activity_group_fixture(attrs \\ %{}) do
    {:ok, activity_group} =
      attrs
      |> Enum.into(%{
        name: "some title",
        description: "some description"
      })
      |> ActivityPlanner.Activities.create_activity_group()

      activity_group
  end
end
