defmodule ActivityPlanner.ParticipantsTest do
  use ActivityPlanner.DataCase

  alias ActivityPlanner.Participants
  alias ActivityPlanner.Participants.Participant

  describe "participants" do
    import ActivityPlanner.Factory

    @invalid_attrs %{email: nil, name: nil, phone: nil}

    test "list_participants/0 returns all participants" do
      participant = insert!(:participant)
      [%Participant{}] = Participants.list_participants(company_id: participant.company_id)
    end

    test "get_participant!/1 returns the participant with given id" do
      participant = insert!(:participant)

      %Participant{} =
        Participants.get_participant!(participant.id, company_id: participant.company_id)
    end

    test "create_participant/1 with valid data creates a participant" do
      company = insert!(:company)

      valid_attrs = %{
        email: "some@email",
        name: "some name",
        phone: "some phone"
      }

      assert {:ok, %Participant{} = participant} =
               Participants.create_participant(valid_attrs, company_id: company.company_id)

      assert participant.email == "some@email"
      assert participant.name == "some name"
      assert participant.phone == "some phone"
    end

    test "create_participant/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} =
               Participants.create_participant(@invalid_attrs, skip_company_id: true)
    end

    test "update_participant/2 with valid data updates the participant" do
      participant = insert!(:participant)

      update_attrs = %{
        email: "some.updated@email",
        name: "some updated name",
        phone: "some updated phone"
      }

      assert {:ok, %Participant{} = participant} =
               Participants.update_participant(participant, update_attrs)

      assert participant.email == "some.updated@email"
      assert participant.name == "some updated name"
      assert participant.phone == "some updated phone"
    end

    test "update_participant/2 with invalid data returns error changeset" do
      participant = insert!(:participant)

      assert {:error, %Ecto.Changeset{}} =
               Participants.update_participant(participant, @invalid_attrs)

      fetched_participant =
        Participants.get_participant!(participant.id, company_id: participant.company_id)

      assert fetched_participant.email == participant.email
      assert fetched_participant.phone == participant.phone
      assert fetched_participant.name == participant.name
    end

    test "delete_participant/1 deletes the participant" do
      participant = insert!(:participant)

      assert {:ok, %Participant{}} =
               Participants.delete_participant(participant)

      assert_raise Ecto.NoResultsError, fn ->
        Participants.get_participant!(participant.id, company_id: participant.company_id)
      end
    end

    test "change_participant/1 returns a participant changeset" do
      company = insert!(:company)
      participant = insert!(:participant, company: company)
      assert %Ecto.Changeset{} = Participants.change_participant(participant)
    end
  end
end
