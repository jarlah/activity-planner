defmodule ActivityPlannerWeb.ActivityLive.Index do
  alias ActivityPlanner.Participants
  use ActivityPlannerWeb, :live_view

  alias ActivityPlanner.Activities
  alias ActivityPlanner.Activities.Activity

  @impl true
  def mount(_params, _session, socket) do
    {
      :ok,
      socket
      |> stream(:activities, Activities.list_activities())
      |> assign(:activity_groups, Activities.list_activity_groups())
      |> assign(:participants, Participants.list_participants())
    }
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Activity")
    |> assign(:activity, Activities.get_activity!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Activity")
    |> assign(:activity, %Activity{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Activities")
    |> assign(:activity, nil)
  end

  @impl true
  def handle_info({ActivityPlannerWeb.ActivityLive.FormComponent, {:saved, activity}}, socket) do
    {:noreply, stream_insert(socket, :activities, activity)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    activity = Activities.get_activity!(id)
    {:ok, _} = Activities.delete_activity(activity)

    {:noreply, stream_delete(socket, :activities, activity)}
  end
end
