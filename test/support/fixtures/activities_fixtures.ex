defmodule ActivityPlanner.ActivitiesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ActivityPlanner.Activities` context.
  """

  @doc """
  Generate a activity.
  """
  def activity_fixture(attrs \\ %{}) do
    {:ok, activity} =
      attrs
      |> Enum.into(%{
        description: "some description",
        start_time: ~U[2023-09-19 06:31:00Z],
        end_time: ~U[2023-09-19 06:31:00Z]
      })
      |> ActivityPlanner.Activities.create_activity()

    activity
  end
end
