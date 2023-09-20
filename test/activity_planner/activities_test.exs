defmodule ActivityPlanner.ActivitiesTest do
  use ActivityPlanner.DataCase

  alias ActivityPlanner.Activities

  describe "activities" do
    alias ActivityPlanner.Activities.Activity

    import ActivityPlanner.ActivitiesFixtures

    @invalid_attrs %{description: nil, start_time: nil, end_time: nil}

    test "list_activities/0 returns all activities" do
      activity = activity_fixture()
      assert Activities.list_activities() == [activity]
    end

    test "get_activity!/1 returns the activity with given id" do
      activity = activity_fixture()
      assert Activities.get_activity!(activity.id) == activity
    end

    test "create_activity/1 with valid data creates a activity" do
      valid_attrs = %{description: "some description", start_time: ~U[2023-09-19 06:31:00Z], end_time: ~U[2023-09-19 06:31:00Z]}

      assert {:ok, %Activity{} = activity} = Activities.create_activity(valid_attrs)
      assert activity.description == "some description"
      assert activity.start_time == ~U[2023-09-19 06:31:00Z]
      assert activity.end_time == ~U[2023-09-19 06:31:00Z]
    end

    test "create_activity/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Activities.create_activity(@invalid_attrs)
    end

    test "update_activity/2 with valid data updates the activity" do
      activity = activity_fixture()
      update_attrs = %{description: "some updated description", start_time: ~U[2023-09-20 06:31:00Z], end_time: ~U[2023-09-20 06:31:00Z]}

      assert {:ok, %Activity{} = activity} = Activities.update_activity(activity, update_attrs)
      assert activity.description == "some updated description"
      assert activity.start_time == ~U[2023-09-20 06:31:00Z]
      assert activity.end_time == ~U[2023-09-20 06:31:00Z]
    end

    test "update_activity/2 with invalid data returns error changeset" do
      activity = activity_fixture()
      assert {:error, %Ecto.Changeset{}} = Activities.update_activity(activity, @invalid_attrs)
      assert activity == Activities.get_activity!(activity.id)
    end

    test "delete_activity/1 deletes the activity" do
      activity = activity_fixture()
      assert {:ok, %Activity{}} = Activities.delete_activity(activity)
      assert_raise Ecto.NoResultsError, fn -> Activities.get_activity!(activity.id) end
    end

    test "change_activity/1 returns a activity changeset" do
      activity = activity_fixture()
      assert %Ecto.Changeset{} = Activities.change_activity(activity)
    end
  end
end
