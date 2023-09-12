defmodule ActivityPlannerWeb.ActivityParticipantController do
  use ActivityPlannerWeb, :controller

  alias ActivityPlanner.Schemas
  alias ActivityPlanner.Schemas.ActivityParticipant
  alias ActivityPlanner.Schemas.Participant
  alias ActivityPlanner.Schemas.Activity

  def index(conn, _params) do
    activity_participants = Schemas.list_activity_participants() |> ActivityPlanner.Repo.preload([:activity, :participant])
    render(conn, :index, activity_participants: activity_participants)
  end

  def new(conn, _params) do
    changeset = Schemas.change_activity_participant(%ActivityParticipant{})
    participants = ActivityPlanner.Repo.all(Participant)
    activities = ActivityPlanner.Repo.all(Activity)
    render(conn, :new, changeset: changeset, participants: participants, activities: activities)
  end

  def create(conn, %{"activity_participant" => activity_participant_params}) do
    case Schemas.create_activity_participant(activity_participant_params) do
      {:ok, activity_participant} ->
        conn
        |> put_flash(:info, "Activity participant created successfully.")
        |> redirect(to: ~p"/activity_participants/#{activity_participant}")

      {:error, %Ecto.Changeset{} = changeset} ->
        participants = ActivityPlanner.Repo.all(Participant)
        activities = ActivityPlanner.Repo.all(Activity)
        render(conn, :new, changeset: changeset, participants: participants, activities: activities)
    end
  end

  def show(conn, %{"id" => id}) do
    activity_participant = Schemas.get_activity_participant!(id) |> ActivityPlanner.Repo.preload([:activity, :participant])
    render(conn, :show, activity_participant: activity_participant)
  end

  def edit(conn, %{"id" => id}) do
    activity_participant = Schemas.get_activity_participant!(id)
    changeset = Schemas.change_activity_participant(activity_participant)
    participants = ActivityPlanner.Repo.all(Participant)
    activities = ActivityPlanner.Repo.all(Activity)
    render(conn, :edit, activity_participant: activity_participant, changeset: changeset, participants: participants, activities: activities)
  end

  def update(conn, %{"id" => id, "activity_participant" => activity_participant_params}) do
    activity_participant = Schemas.get_activity_participant!(id)

    case Schemas.update_activity_participant(activity_participant, activity_participant_params) do
      {:ok, activity_participant} ->
        conn
        |> put_flash(:info, "Activity participant updated successfully.")
        |> redirect(to: ~p"/activity_participants/#{activity_participant}")

      {:error, %Ecto.Changeset{} = changeset} ->
        participants = ActivityPlanner.Repo.all(Participant)
        activities = ActivityPlanner.Repo.all(Activity)
        render(conn, :edit, activity_participant: activity_participant, changeset: changeset, participants: participants, activities: activities)
    end
  end

  def delete(conn, %{"id" => id}) do
    activity_participant = Schemas.get_activity_participant!(id)
    {:ok, _activity_participant} = Schemas.delete_activity_participant(activity_participant)

    conn
    |> put_flash(:info, "Activity participant deleted successfully.")
    |> redirect(to: ~p"/activity_participants")
  end
end
