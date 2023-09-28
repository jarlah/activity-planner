defmodule ActivityPlanner.ActivitiesTest do
  use ActivityPlanner.DataCase

  alias ActivityPlanner.Activities.Activity
  alias ActivityPlanner.Activities.ActivityParticipant
  alias ActivityPlanner.Activities.ActivityGroup

  import ActivityPlanner.Activities

  import ActivityPlanner.ActivitiesFixtures
  import ActivityPlanner.ActivityGroupFixtures
  import ActivityPlanner.CompanyFixtures
  import ActivityPlanner.SchemasFixtures

  doctest ActivityPlanner.Activities

  describe "activities" do

    @invalid_attrs %{description: nil, start_time: nil, end_time: nil}

    test "list_activities/0 returns all activities" do
      company = company_fixture()
      participant = participant_fixture(%{ company_id: company.company_id })
      activity_group = activity_group_fixture(%{ company_id: company.company_id })
      activity = activity_fixture(%{ company_id: company.company_id, activity_group_id: activity_group.id, responsible_participant_id: participant.id })
      assert list_activities(skip_company_id: true) == [activity]
    end

    test "get_activity!/1 returns the activity with given id" do
      company = company_fixture()
      participant = participant_fixture(%{ company_id: company.company_id })
      activity_group = activity_group_fixture(%{ company_id: company.company_id })
      activity = activity_fixture(%{ company_id: company.company_id, activity_group_id: activity_group.id, responsible_participant_id: participant.id })
      assert get_activity!(activity.id, skip_company_id: true) == activity
    end

    test "create_activity/1 with valid data creates a activity" do
      company = company_fixture()
      participant = participant_fixture(%{ company_id: company.company_id })
      activity_group = activity_group_fixture(%{ company_id: company.company_id })

      valid_attrs = %{description: "some description", start_time: ~U[2023-09-19 06:31:00Z], end_time: ~U[2023-09-19 06:31:00Z], company_id: company.company_id, activity_group_id: activity_group.id, responsible_participant_id: participant.id}

      assert {:ok, %Activity{} = activity} = create_activity(valid_attrs)
      assert activity.description == "some description"
      assert activity.start_time == ~U[2023-09-19 06:31:00Z]
      assert activity.end_time == ~U[2023-09-19 06:31:00Z]
    end

    test "create_activity/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = create_activity(@invalid_attrs)
    end

    test "update_activity/2 with valid data updates the activity" do
      company = company_fixture()
      participant = participant_fixture(%{ company_id: company.company_id })
      activity_group = activity_group_fixture(%{ company_id: company.company_id })
      activity = activity_fixture(%{ company_id: company.company_id, activity_group_id: activity_group.id, responsible_participant_id: participant.id })
      update_attrs = %{description: "some updated description", start_time: ~U[2023-09-20 06:31:00Z], end_time: ~U[2023-09-20 06:31:00Z]}

      assert {:ok, %Activity{} = activity} = update_activity(activity, update_attrs)
      assert activity.description == "some updated description"
      assert activity.start_time == ~U[2023-09-20 06:31:00Z]
      assert activity.end_time == ~U[2023-09-20 06:31:00Z]
    end

    test "update_activity/2 with invalid data returns error changeset" do
      company = company_fixture()
      participant = participant_fixture(%{ company_id: company.company_id })
      activity_group = activity_group_fixture(%{ company_id: company.company_id })
      activity = activity_fixture(%{ company_id: company.company_id, activity_group_id: activity_group.id, responsible_participant_id: participant.id })
      assert {:error, %Ecto.Changeset{}} = update_activity(activity, @invalid_attrs, skip_company_id: true)
      assert activity == get_activity!(activity.id, skip_company_id: true)
    end

    test "delete_activity/1 deletes the activity" do
      company = company_fixture()
      participant = participant_fixture(%{ company_id: company.company_id })
      activity_group = activity_group_fixture(%{ company_id: company.company_id })
      activity = activity_fixture(%{ company_id: company.company_id, activity_group_id: activity_group.id, responsible_participant_id: participant.id })
      assert {:ok, %Activity{}} = delete_activity(activity, skip_company_id: true)
      assert_raise Ecto.NoResultsError, fn -> get_activity!(activity.id, skip_company_id: true) end
    end

    test "change_activity/1 returns a activity changeset" do
      company = company_fixture()
      participant = participant_fixture(%{ company_id: company.company_id })
      activity_group = activity_group_fixture(%{ company_id: company.company_id })
      activity = activity_fixture(%{ company_id: company.company_id, activity_group_id: activity_group.id, responsible_participant_id: participant.id })
      assert %Ecto.Changeset{} = change_activity(activity)
    end
  end
end
