defmodule ActivityPlanner.SchemasTest do
  use ActivityPlanner.DataCase

  alias ActivityPlanner.Schemas

  describe "participants" do
    alias ActivityPlanner.Schemas.Participant

    import ActivityPlanner.SchemasFixtures

    @invalid_attrs %{email: nil, name: nil, phone: nil}

    test "list_participants/0 returns all participants" do
      participant = participant_fixture()
      assert Schemas.list_participants() == [participant]
    end

    test "get_participant!/1 returns the participant with given id" do
      participant = participant_fixture()
      assert Schemas.get_participant!(participant.id) == participant
    end

    test "create_participant/1 with valid data creates a participant" do
      valid_attrs = %{email: "some email", name: "some name", phone: "some phone"}

      assert {:ok, %Participant{} = participant} = Schemas.create_participant(valid_attrs)
      assert participant.email == "some email"
      assert participant.name == "some name"
      assert participant.phone == "some phone"
    end

    test "create_participant/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Schemas.create_participant(@invalid_attrs)
    end

    test "update_participant/2 with valid data updates the participant" do
      participant = participant_fixture()
      update_attrs = %{email: "some updated email", name: "some updated name", phone: "some updated phone"}

      assert {:ok, %Participant{} = participant} = Schemas.update_participant(participant, update_attrs)
      assert participant.email == "some updated email"
      assert participant.name == "some updated name"
      assert participant.phone == "some updated phone"
    end

    test "update_participant/2 with invalid data returns error changeset" do
      participant = participant_fixture()
      assert {:error, %Ecto.Changeset{}} = Schemas.update_participant(participant, @invalid_attrs)
      assert participant == Schemas.get_participant!(participant.id)
    end

    test "delete_participant/1 deletes the participant" do
      participant = participant_fixture()
      assert {:ok, %Participant{}} = Schemas.delete_participant(participant)
      assert_raise Ecto.NoResultsError, fn -> Schemas.get_participant!(participant.id) end
    end

    test "change_participant/1 returns a participant changeset" do
      participant = participant_fixture()
      assert %Ecto.Changeset{} = Schemas.change_participant(participant)
    end
  end

  describe "activities" do
    alias ActivityPlanner.Schemas.Activity

    import ActivityPlanner.SchemasFixtures

    @invalid_attrs %{end_time: nil, start_time: nil, title: nil}

    test "list_activities/0 returns all activities" do
      activity = activity_fixture()
      assert Schemas.list_activities() == [activity]
    end

    test "get_activity!/1 returns the activity with given id" do
      activity = activity_fixture()
      assert Schemas.get_activity!(activity.id) == activity
    end

    test "create_activity/1 with valid data creates a activity" do
      responsible_participant = participant_fixture()

      valid_attrs = %{end_time: ~U[2023-09-10 18:09:00Z], start_time: ~U[2023-09-10 18:09:00Z], title: "some title", responsible_participant_id: responsible_participant.id}

      assert {:ok, %Activity{} = activity} = Schemas.create_activity(valid_attrs)
      assert activity.end_time == ~U[2023-09-10 18:09:00Z]
      assert activity.start_time == ~U[2023-09-10 18:09:00Z]
      assert activity.title == "some title"
    end

    test "create_activity/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Schemas.create_activity(@invalid_attrs)
    end

    test "update_activity/2 with valid data updates the activity" do
      activity = activity_fixture()
      update_attrs = %{end_time: ~U[2023-09-11 18:09:00Z], start_time: ~U[2023-09-11 18:09:00Z], title: "some updated title"}

      assert {:ok, %Activity{} = activity} = Schemas.update_activity(activity, update_attrs)
      assert activity.end_time == ~U[2023-09-11 18:09:00Z]
      assert activity.start_time == ~U[2023-09-11 18:09:00Z]
      assert activity.title == "some updated title"
    end

    test "update_activity/2 with invalid data returns error changeset" do
      activity = activity_fixture()
      assert {:error, %Ecto.Changeset{}} = Schemas.update_activity(activity, @invalid_attrs)
      assert activity == Schemas.get_activity!(activity.id)
    end

    test "delete_activity/1 deletes the activity" do
      activity = activity_fixture()
      assert {:ok, %Activity{}} = Schemas.delete_activity(activity)
      assert_raise Ecto.NoResultsError, fn -> Schemas.get_activity!(activity.id) end
    end

    test "change_activity/1 returns a activity changeset" do
      activity = activity_fixture()
      assert %Ecto.Changeset{} = Schemas.change_activity(activity)
    end
  end

  describe "activity_participants" do
    alias ActivityPlanner.Schemas.ActivityParticipant

    import ActivityPlanner.SchemasFixtures

    @invalid_attrs %{ participant_id: nil, activity_id: nil }

    test "list_activity_participants/0 returns all activity_participants" do
      activity_participant = activity_participant_fixture()
      assert Schemas.list_activity_participants() == [activity_participant]
    end

    test "get_activity_participant!/1 returns the activity_participant with given id" do
      activity_participant = activity_participant_fixture()
      assert Schemas.get_activity_participant!(activity_participant.id) == activity_participant
    end

    test "create_activity_participant/1 with valid data creates a activity_participant" do
      participant = participant_fixture()
      activity = activity_fixture()

      valid_attrs = %{participant_id: participant.id, activity_id: activity.id }

      assert {:ok, %ActivityParticipant{}} = Schemas.create_activity_participant(valid_attrs)
    end

    test "create_activity_participant/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Schemas.create_activity_participant(@invalid_attrs)
    end

    test "update_activity_participant/2 with valid data updates the activity_participant" do
      activity_participant = activity_participant_fixture()
      update_attrs = %{}

      assert {:ok, %ActivityParticipant{}} = Schemas.update_activity_participant(activity_participant, update_attrs)
    end

    test "update_activity_participant/2 with invalid data returns error changeset" do
      activity_participant = activity_participant_fixture()
      assert {:error, %Ecto.Changeset{}} = Schemas.update_activity_participant(activity_participant, @invalid_attrs)
      assert activity_participant == Schemas.get_activity_participant!(activity_participant.id)
    end

    test "delete_activity_participant/1 deletes the activity_participant" do
      activity_participant = activity_participant_fixture()
      assert {:ok, %ActivityParticipant{}} = Schemas.delete_activity_participant(activity_participant)
      assert_raise Ecto.NoResultsError, fn -> Schemas.get_activity_participant!(activity_participant.id) end
    end

    test "change_activity_participant/1 returns a activity_participant changeset" do
      activity_participant = activity_participant_fixture()
      assert %Ecto.Changeset{} = Schemas.change_activity_participant(activity_participant)
    end
  end

  @fixed_time ~U[1970-01-01T00:00:00Z]

  describe "get_activities_in_time_range/2" do
    import ActivityPlanner.SchemasFixtures

    test "retrieves activities within the specified time range" do
      _activity0 = activity_fixture(%{start_time: Timex.shift(@fixed_time, days: -4), end_time: Timex.shift(@fixed_time, days: -3)})
      activity1 = activity_fixture(%{}, @fixed_time)
      _activity2 = activity_fixture(%{start_time: Timex.shift(@fixed_time, days: 3), end_time: Timex.shift(@fixed_time, days: 4)})

      minTime = @fixed_time
      maxTime = Timex.shift(@fixed_time, days: 2)

      [activity_one] = Schemas.get_activities_in_time_range(minTime, maxTime)

      assert activity_one == activity1
    end
  end

  describe "get_activities_for_the_next_two_days/0" do
    import ActivityPlanner.SchemasFixtures

    test "retrieves activities for the next two days" do
      # Create some fixtures with a fixed time
      activity1 = activity_fixture(%{start_time: @fixed_time, end_time: Timex.shift(@fixed_time, days: 1)})
      _activity2 = activity_fixture(%{start_time: Timex.shift(@fixed_time, days: 3), end_time: Timex.shift(@fixed_time, days: 4)})

      [activity_one] = Schemas.get_activities_for_the_next_two_days(@fixed_time)

      assert activity_one == activity1
    end
  end

  describe "get_activities_for_the_last_two_days/0" do
    import ActivityPlanner.SchemasFixtures

    test "retrieves activities for the last two days" do
      # Create some fixtures with a fixed time
      activity1 = activity_fixture(%{start_time: Timex.shift(@fixed_time, days: -1), end_time: @fixed_time})
      _activity2 = activity_fixture(%{start_time: Timex.shift(@fixed_time, days: 3), end_time: Timex.shift(@fixed_time, days: 4)})

      [activity_one] = Schemas.get_activities_for_the_last_two_days(@fixed_time)

      assert activity_one == activity1
    end
  end
end
