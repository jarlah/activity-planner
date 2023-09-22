defmodule ActivityPlannerWeb.ActivityParticipantLive.Index do
  alias ActivityPlanner.Participants
  use ActivityPlannerWeb, :live_view

  alias ActivityPlanner.Activities
  alias ActivityPlanner.Activities.ActivityParticipant

  @impl true
  def mount(_params, _session, socket) do
    {
      :ok,
      socket
      |> stream(:activity_participants, Activities.list_activity_participants())
      |> assign(:activities, Activities.list_activities())
      |> assign(:participants, Participants.list_participants())
    }
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit activity participant")
    |> assign(:activity_participant, Activities.get_activity_participant!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New activity participant")
    |> assign(:activity_participant, %ActivityParticipant{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing activity participants")
    |> assign(:activity_participant, nil)
  end

  @impl true
  def handle_info({ActivityPlannerWeb.ActivityParticipantLive.FormComponent, {:saved, activity_participant}}, socket) do
    {:noreply, stream_insert(socket, :activity_participants, activity_participant)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    activity_participant = Activities.get_activity_participant!(id)
    {:ok, _} = Activities.delete_activity_participant(activity_participant)

    {:noreply, stream_delete(socket, :activity_participants, activity_participant) |> put_flash(:info, "Activity participant deleted successfully") }
  end
end
