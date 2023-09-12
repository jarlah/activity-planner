defmodule ActivityPlannerWeb.ActivityController do
  use ActivityPlannerWeb, :controller

  alias ActivityPlanner.Schemas
  alias ActivityPlanner.Schemas.Activity
  alias ActivityPlanner.Schemas.Participant

  def index(conn, _params) do
    activities = Schemas.list_activities() |> ActivityPlanner.Repo.preload([:responsible_participant])
    render(conn, :index, activities: activities)
  end

  def new(conn, _params) do
    changeset = Schemas.change_activity(%Activity{})
    participants = ActivityPlanner.Repo.all(Participant)
    render(conn, :new, changeset: changeset, participants: participants)
  end

  def create(conn, %{"activity" => activity_params}) do
    case Schemas.create_activity(activity_params) do
      {:ok, activity} ->
        conn
        |> put_flash(:info, "Activity created successfully.")
        |> redirect(to: ~p"/activities/#{activity}")

      {:error, %Ecto.Changeset{} = changeset} ->
        participants = ActivityPlanner.Repo.all(Participant)
        render(conn, :new, changeset: changeset, participants: participants)
    end
  end

  def show(conn, %{"id" => id}) do
    activity = Schemas.get_activity!(id) |> ActivityPlanner.Repo.preload([:responsible_participant])
    render(conn, :show, activity: activity)
  end

  def edit(conn, %{"id" => id}) do
    activity = Schemas.get_activity!(id) |> ActivityPlanner.Repo.preload([:responsible_participant])
    changeset = Schemas.change_activity(activity)
    participants = ActivityPlanner.Repo.all(Participant)
    render(conn, :edit, activity: activity, changeset: changeset, participants: participants)
  end

  def update(conn, %{"id" => id, "activity" => activity_params}) do
    activity = Schemas.get_activity!(id) |> ActivityPlanner.Repo.preload([:responsible_participant])

    case Schemas.update_activity(activity, activity_params) do
      {:ok, activity} ->
        conn
        |> put_flash(:info, "Activity updated successfully.")
        |> redirect(to: ~p"/activities/#{activity}")

      {:error, %Ecto.Changeset{} = changeset} ->
        participants = ActivityPlanner.Repo.all(Participant)
        render(conn, :edit, activity: activity, changeset: changeset, participants: participants)
    end
  end

  def delete(conn, %{"id" => id}) do
    activity = Schemas.get_activity!(id)
    {:ok, _activity} = Schemas.delete_activity(activity)

    conn
    |> put_flash(:info, "Activity deleted successfully.")
    |> redirect(to: ~p"/activities")
  end
end
