defmodule ActivityPlanner.SchemasPleaseRenameMeTest do
  use ActivityPlanner.DataCase

  alias ActivityPlanner.Activities
  alias ActivityPlanner.Participants

  describe "participants" do
    alias ActivityPlanner.Participants.Participant

    import ActivityPlanner.ActivityFixtures
    import ActivityPlanner.CompanyFixtures
    import ActivityPlanner.ParticipantFixtures

    @invalid_attrs %{email: nil, name: nil, phone: nil}

    test "list_participants/0 returns all participants" do
      company = company_fixture()
      participant = participant_fixture(%{company_id: company.company_id})
      assert Participants.list_participants(skip_company_id: true) == [participant]
    end

    test "get_participant!/1 returns the participant with given id" do
      company = company_fixture()
      participant = participant_fixture(%{company_id: company.company_id})
      assert Participants.get_participant!(participant.id, skip_company_id: true) == participant
    end

    test "create_participant/1 with valid data creates a participant" do
      company = company_fixture()

      valid_attrs = %{
        email: "some@email",
        name: "some name",
        phone: "some phone",
        company_id: company.company_id
      }

      assert {:ok, %Participant{} = participant} =
               Participants.create_participant(valid_attrs, skip_company_id: true)

      assert participant.email == "some@email"
      assert participant.name == "some name"
      assert participant.phone == "some phone"
    end

    test "create_participant/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} =
               Participants.create_participant(@invalid_attrs, skip_company_id: true)
    end

    test "update_participant/2 with valid data updates the participant" do
      company = company_fixture()
      participant = participant_fixture(%{company_id: company.company_id})

      update_attrs = %{
        email: "some.updated@email",
        name: "some updated name",
        phone: "some updated phone"
      }

      assert {:ok, %Participant{} = participant} =
               Participants.update_participant(participant, update_attrs, skip_company_id: true)

      assert participant.email == "some.updated@email"
      assert participant.name == "some updated name"
      assert participant.phone == "some updated phone"
    end

    test "update_participant/2 with invalid data returns error changeset" do
      company = company_fixture()
      participant = participant_fixture(%{company_id: company.company_id})

      assert {:error, %Ecto.Changeset{}} =
               Participants.update_participant(participant, @invalid_attrs, skip_company_id: true)

      assert participant == Participants.get_participant!(participant.id, skip_company_id: true)
    end

    test "delete_participant/1 deletes the participant" do
      company = company_fixture()
      participant = participant_fixture(%{company_id: company.company_id})

      assert {:ok, %Participant{}} =
               Participants.delete_participant(participant, skip_company_id: true)

      assert_raise Ecto.NoResultsError, fn ->
        Participants.get_participant!(participant.id, skip_company_id: true)
      end
    end

    test "change_participant/1 returns a participant changeset" do
      company = company_fixture()
      participant = participant_fixture(%{company_id: company.company_id})
      assert %Ecto.Changeset{} = Participants.change_participant(participant)
    end
  end

  describe "activities" do
    alias ActivityPlanner.Activities.Activity

    import ActivityPlanner.ActivityFixtures
    import ActivityPlanner.CompanyFixtures
    import ActivityPlanner.ActivityGroupFixtures
    import ActivityPlanner.ParticipantFixtures

    @invalid_attrs %{end_time: nil, start_time: nil, title: nil}

    test "list_activities/0 returns all activities" do
      activity = activity_fixture()
      assert Activities.list_activities(skip_company_id: true) == [activity]
    end

    test "get_activity!/1 returns the activity with given id" do
      activity = activity_fixture()
      assert Activities.get_activity!(activity.id, skip_company_id: true) == activity
    end

    test "create_activity/1 with valid data creates a activity" do
      company = company_fixture()
      responsible_participant = participant_fixture(%{company_id: company.company_id})
      activity_group = activity_group_fixture(%{company_id: company.company_id})

      valid_attrs = %{
        end_time: ~U[2023-09-10 18:09:00Z],
        start_time: ~U[2023-09-10 18:09:00Z],
        title: "some title",
        responsible_participant_id: responsible_participant.id,
        activity_group_id: activity_group.id,
        company_id: company.company_id
      }

      assert {:ok, %Activity{} = activity} = Activities.create_activity(valid_attrs)
      assert activity.end_time == ~U[2023-09-10 18:09:00Z]
      assert activity.start_time == ~U[2023-09-10 18:09:00Z]
    end

    test "create_activity/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Activities.create_activity(@invalid_attrs)
    end

    test "update_activity/2 with valid data updates the activity" do
      activity = activity_fixture()

      update_attrs = %{
        end_time: ~U[2023-09-11 18:09:00Z],
        start_time: ~U[2023-09-11 18:09:00Z],
        title: "some updated title"
      }

      assert {:ok, %Activity{} = activity} = Activities.update_activity(activity, update_attrs)
      assert activity.end_time == ~U[2023-09-11 18:09:00Z]
      assert activity.start_time == ~U[2023-09-11 18:09:00Z]
    end

    test "update_activity/2 with invalid data returns error changeset" do
      activity = activity_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Activities.update_activity(activity, @invalid_attrs, skip_company_id: true)

      assert activity == Activities.get_activity!(activity.id, skip_company_id: true)
    end

    test "delete_activity/1 deletes the activity" do
      activity = activity_fixture()
      assert {:ok, %Activity{}} = Activities.delete_activity(activity, skip_company_id: true)

      assert_raise Ecto.NoResultsError, fn ->
        Activities.get_activity!(activity.id, skip_company_id: true)
      end
    end

    test "change_activity/1 returns a activity changeset" do
      activity = activity_fixture()
      assert %Ecto.Changeset{} = Activities.change_activity(activity)
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

      assert Activities.list_activity_participants(skip_company_id: true) == [
               activity_participant
             ]
    end

    test "get_activity_participant!/1 returns the activity_participant with given id" do
      activity_participant = activity_participant_fixture()

      assert Activities.get_activity_participant!(activity_participant.id, skip_company_id: true) ==
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

      assert {:ok, %ActivityParticipant{}} = Activities.create_activity_participant(valid_attrs)
    end

    test "create_activity_participant/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Activities.create_activity_participant(@invalid_attrs)
    end

    test "update_activity_participant/2 with valid data updates the activity_participant" do
      activity_participant = activity_participant_fixture()
      update_attrs = %{}

      assert {:ok, %ActivityParticipant{}} =
               Activities.update_activity_participant(activity_participant, update_attrs)
    end

    test "update_activity_participant/2 with invalid data returns error changeset" do
      activity_participant = activity_participant_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Activities.update_activity_participant(activity_participant, @invalid_attrs)

      assert activity_participant ==
               Activities.get_activity_participant!(activity_participant.id,
                 skip_company_id: true
               )
    end

    test "delete_activity_participant/1 deletes the activity_participant" do
      activity_participant = activity_participant_fixture()

      assert {:ok, %ActivityParticipant{}} =
               Activities.delete_activity_participant(activity_participant)

      assert_raise Ecto.NoResultsError, fn ->
        Activities.get_activity_participant!(activity_participant.id, skip_company_id: true)
      end
    end

    test "change_activity_participant/1 returns a activity_participant changeset" do
      activity_participant = activity_participant_fixture()
      assert %Ecto.Changeset{} = Activities.change_activity_participant(activity_participant)
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
        Activities.get_activities_in_time_range(minTime, maxTime, skip_company_id: true)

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
        Activities.get_activities_for_the_next_two_days(@fixed_time, skip_company_id: true)

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
        Activities.get_activities_for_the_last_two_days(@fixed_time, skip_company_id: true)

      assert activity_one == activity1
    end
  end
end
