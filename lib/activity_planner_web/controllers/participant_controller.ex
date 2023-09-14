defmodule ActivityPlannerWeb.ParticipantController do
  use ActivityPlannerWeb, :controller

  alias ActivityPlanner.Participants
  alias ActivityPlanner.Participants.Participant

  def index(conn, _params) do
    participants = Participants.list_participants()
    render(conn, :index, participants: participants)
  end

  def new(conn, _params) do
    changeset = Participants.change_participant(%Participant{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"participant" => participant_params}) do
    case Participants.create_participant(participant_params) do
      {:ok, participant} ->
        conn
        |> put_flash(:info, "Participant created successfully.")
        |> redirect(to: ~p"/participants/#{participant}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    participant = Participants.get_participant!(id)
    render(conn, :show, participant: participant)
  end

  def edit(conn, %{"id" => id}) do
    participant = Participants.get_participant!(id)
    changeset = Participants.change_participant(participant)
    render(conn, :edit, participant: participant, changeset: changeset)
  end

  def update(conn, %{"id" => id, "participant" => participant_params}) do
    participant = Participants.get_participant!(id)

    case Participants.update_participant(participant, participant_params) do
      {:ok, participant} ->
        conn
        |> put_flash(:info, "Participant updated successfully.")
        |> redirect(to: ~p"/participants/#{participant}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, participant: participant, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    participant = Participants.get_participant!(id)
    {:ok, _participant} = Participants.delete_participant(participant)

    conn
    |> put_flash(:info, "Participant deleted successfully.")
    |> redirect(to: ~p"/participants")
  end
end
