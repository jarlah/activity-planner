defmodule ActivityPlannerWeb.ParticipantLive.Index do
  use ActivityPlannerWeb, :live_view

  alias ActivityPlanner.Participants
  alias ActivityPlanner.Participants.Participant

  @impl true
  def mount(_params, _session, socket) do
    {
      :ok,
      socket
      |> stream(:participants, Participants.list_participants())
    }
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit participant")
    |> assign(:participant, Participants.get_participant!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New participant")
    |> assign(:participant, %Participant{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing participant")
    |> assign(:participant, nil)
  end

  @impl true
  def handle_info({ActivityPlannerWeb.ParticipantLive.FormComponent, {:saved, activity}}, socket) do
    {:noreply, stream_insert(socket, :participants, activity)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    activity = Participants.get_participant!(id)
    {:ok, _} = Participants.delete_participant(activity)

    {:noreply, stream_delete(socket, :participants, activity) |> put_flash(:info, "Participant deleted successfully")  }
  end
end
