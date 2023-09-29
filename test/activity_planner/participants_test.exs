defmodule ActivityPlanner.ParticipantsTest do
  use ActivityPlanner.DataCase

  alias ActivityPlanner.Participants

  describe "participants" do
    alias ActivityPlanner.Participants.Participant

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
end
