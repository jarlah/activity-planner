defmodule ActivityPlanner.ActivitiesTest do
  use ActivityPlanner.DataCase

  alias ActivityPlanner.Activities.Activity
  alias ActivityPlanner.Activities.ActivityParticipant
  alias ActivityPlanner.Activities.ActivityGroup

  import ActivityPlanner.Activities

  import ActivityPlanner.ActivityGroupFixtures
  import ActivityPlanner.CompanyFixtures
  import ActivityPlanner.ActivityFixtures
  import ActivityPlanner.ParticipantFixtures

  doctest ActivityPlanner.Activities

  describe "activities" do
    @invalid_attrs %{description: nil, start_time: nil, end_time: nil}

    test "list_activities/0 returns all activities" do
      company = company_fixture()
      participant = participant_fixture(%{company_id: company.company_id})
      activity_group = activity_group_fixture(%{company_id: company.company_id})

      activity =
        activity_fixture(%{
          company_id: company.company_id,
          activity_group_id: activity_group.id,
          responsible_participant_id: participant.id
        })

      assert list_activities(skip_company_id: true) == [activity]
    end

    test "get_activity!/1 returns the activity with given id" do
      company = company_fixture()
      participant = participant_fixture(%{company_id: company.company_id})
      activity_group = activity_group_fixture(%{company_id: company.company_id})

      activity =
        activity_fixture(%{
          company_id: company.company_id,
          activity_group_id: activity_group.id,
          responsible_participant_id: participant.id
        })

      assert get_activity!(activity.id, skip_company_id: true) == activity
    end

    test "create_activity/1 with valid data creates a activity" do
      company = company_fixture()
      participant = participant_fixture(%{company_id: company.company_id})
      activity_group = activity_group_fixture(%{company_id: company.company_id})

      valid_attrs = %{
        description: "some description",
        start_time: ~U[2023-09-19 06:31:00Z],
        end_time: ~U[2023-09-19 06:31:00Z],
        company_id: company.company_id,
        activity_group_id: activity_group.id,
        responsible_participant_id: participant.id
      }

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
      participant = participant_fixture(%{company_id: company.company_id})
      activity_group = activity_group_fixture(%{company_id: company.company_id})

      activity =
        activity_fixture(%{
          company_id: company.company_id,
          activity_group_id: activity_group.id,
          responsible_participant_id: participant.id
        })

      update_attrs = %{
        description: "some updated description",
        start_time: ~U[2023-09-20 06:31:00Z],
        end_time: ~U[2023-09-20 06:31:00Z]
      }

      assert {:ok, %Activity{} = activity} = update_activity(activity, update_attrs)
      assert activity.description == "some updated description"
      assert activity.start_time == ~U[2023-09-20 06:31:00Z]
      assert activity.end_time == ~U[2023-09-20 06:31:00Z]
    end

    test "update_activity/2 with invalid data returns error changeset" do
      company = company_fixture()
      participant = participant_fixture(%{company_id: company.company_id})
      activity_group = activity_group_fixture(%{company_id: company.company_id})

      activity =
        activity_fixture(%{
          company_id: company.company_id,
          activity_group_id: activity_group.id,
          responsible_participant_id: participant.id
        })

      assert {:error, %Ecto.Changeset{}} =
               update_activity(activity, @invalid_attrs, skip_company_id: true)

      assert activity == get_activity!(activity.id, skip_company_id: true)
    end

    test "delete_activity/1 deletes the activity" do
      company = company_fixture()
      participant = participant_fixture(%{company_id: company.company_id})
      activity_group = activity_group_fixture(%{company_id: company.company_id})

      activity =
        activity_fixture(%{
          company_id: company.company_id,
          activity_group_id: activity_group.id,
          responsible_participant_id: participant.id
        })

      assert {:ok, %Activity{}} = delete_activity(activity, skip_company_id: true)

      assert_raise Ecto.NoResultsError, fn ->
        get_activity!(activity.id, skip_company_id: true)
      end
    end

    test "change_activity/1 returns a activity changeset" do
      company = company_fixture()
      participant = participant_fixture(%{company_id: company.company_id})
      activity_group = activity_group_fixture(%{company_id: company.company_id})

      activity =
        activity_fixture(%{
          company_id: company.company_id,
          activity_group_id: activity_group.id,
          responsible_participant_id: participant.id
        })

      assert %Ecto.Changeset{} = change_activity(activity)
    end
  end

  describe "activity_participants" do
    alias ActivityPlanner.Activities.ActivityParticipant

    import ActivityPlanner.ActivityFixtures
    import ActivityPlanner.CompanyFixtures
    import ActivityPlanner.ParticipantFixtures

    @invalid_attrs %{participant_id: nil, activity_id: nil}

    test "list_activity_participants/0 returns all activity_participants" do
      activity_participant = activity_participant_fixture()

      assert list_activity_participants(skip_company_id: true) == [
               activity_participant
             ]
    end

    test "get_activity_participant!/1 returns the activity_participant with given id" do
      activity_participant = activity_participant_fixture()

      assert get_activity_participant!(activity_participant.id, skip_company_id: true) ==
               activity_participant
    end

    test "create_activity_participant/1 with valid data creates a activity_participant" do
      company = company_fixture()
      participant = participant_fixture(%{company_id: company.company_id})
      activity = activity_fixture(%{company_id: company.company_id})

      valid_attrs = %{
        participant_id: participant.id,
        activity_id: activity.id,
        company_id: company.company_id
      }

      assert {:ok, %ActivityParticipant{}} = create_activity_participant(valid_attrs)
    end

    test "create_activity_participant/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = create_activity_participant(@invalid_attrs)
    end

    test "update_activity_participant/2 with valid data updates the activity_participant" do
      activity_participant = activity_participant_fixture()
      update_attrs = %{}

      assert {:ok, %ActivityParticipant{}} =
               update_activity_participant(activity_participant, update_attrs)
    end

    test "update_activity_participant/2 with invalid data returns error changeset" do
      activity_participant = activity_participant_fixture()

      assert {:error, %Ecto.Changeset{}} =
               update_activity_participant(activity_participant, @invalid_attrs)

      assert activity_participant ==
               get_activity_participant!(activity_participant.id,
                 skip_company_id: true
               )
    end

    test "delete_activity_participant/1 deletes the activity_participant" do
      activity_participant = activity_participant_fixture()

      assert {:ok, %ActivityParticipant{}} =
               delete_activity_participant(activity_participant)

      assert_raise Ecto.NoResultsError, fn ->
        get_activity_participant!(activity_participant.id, skip_company_id: true)
      end
    end

    test "change_activity_participant/1 returns a activity_participant changeset" do
      activity_participant = activity_participant_fixture()
      assert %Ecto.Changeset{} = change_activity_participant(activity_participant)
    end
  end

  @fixed_time ~U[1970-01-01T00:00:00Z]

  describe "get_activities_in_time_range/2" do
    import ActivityPlanner.ActivityFixtures

    test "retrieves activities within the specified time range" do
      _activity0 =
        activity_fixture(%{
          start_time: Timex.shift(@fixed_time, days: -4),
          end_time: Timex.shift(@fixed_time, days: -3)
        })

      activity1 = activity_fixture(%{}, @fixed_time)

      _activity2 =
        activity_fixture(%{
          start_time: Timex.shift(@fixed_time, days: 3),
          end_time: Timex.shift(@fixed_time, days: 4)
        })

      minTime = @fixed_time
      maxTime = Timex.shift(@fixed_time, days: 2)

      [activity_one] =
        get_activities_in_time_range(minTime, maxTime, skip_company_id: true)

      assert activity_one == activity1
    end
  end

  describe "get_activities_for_the_next_two_days/0" do
    import ActivityPlanner.ActivityFixtures

    test "retrieves activities for the next two days" do
      # Create some fixtures with a fixed time
      activity1 =
        activity_fixture(%{
          start_time: @fixed_time,
          end_time: Timex.shift(@fixed_time, days: 1)
        })

      _activity2 =
        activity_fixture(%{
          start_time: Timex.shift(@fixed_time, days: 3),
          end_time: Timex.shift(@fixed_time, days: 4)
        })

      [activity_one] =
        get_activities_for_the_next_two_days(@fixed_time, skip_company_id: true)

      assert activity_one == activity1
    end
  end

  describe "get_activities_for_the_last_two_days/0" do
    import ActivityPlanner.ActivityFixtures

    test "retrieves activities for the last two days" do
      # Create some fixtures with a fixed time
      activity1 =
        activity_fixture(%{
          start_time: Timex.shift(@fixed_time, days: -1),
          end_time: @fixed_time
        })

      _activity2 =
        activity_fixture(%{
          start_time: Timex.shift(@fixed_time, days: 3),
          end_time: Timex.shift(@fixed_time, days: 4)
        })

      [activity_one] =
        get_activities_for_the_last_two_days(@fixed_time, skip_company_id: true)

      assert activity_one == activity1
    end
  end
end
