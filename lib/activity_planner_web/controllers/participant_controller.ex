defmodule ActivityPlannerWeb.ParticipantController do
  use ActivityPlannerWeb, :controller

  alias ActivityPlanner.Schemas
  alias ActivityPlanner.Schemas.Participant

  def index(conn, _params) do
    participants = Schemas.list_participants()
    render(conn, :index, participants: participants)
  end

  def new(conn, _params) do
    changeset = Schemas.change_participant(%Participant{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"participant" => participant_params}) do
    case Schemas.create_participant(participant_params) do
      {:ok, participant} ->
        conn
        |> put_flash(:info, "Participant created successfully.")
        |> redirect(to: ~p"/participants/#{participant}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    participant = Schemas.get_participant!(id)
    render(conn, :show, participant: participant)
  end

  def edit(conn, %{"id" => id}) do
    participant = Schemas.get_participant!(id)
    changeset = Schemas.change_participant(participant)
    render(conn, :edit, participant: participant, changeset: changeset)
  end

  def update(conn, %{"id" => id, "participant" => participant_params}) do
    participant = Schemas.get_participant!(id)

    case Schemas.update_participant(participant, participant_params) do
      {:ok, participant} ->
        conn
        |> put_flash(:info, "Participant updated successfully.")
        |> redirect(to: ~p"/participants/#{participant}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, participant: participant, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    participant = Schemas.get_participant!(id)
    {:ok, _participant} = Schemas.delete_participant(participant)

    conn
    |> put_flash(:info, "Participant deleted successfully.")
    |> redirect(to: ~p"/participants")
  end
end
