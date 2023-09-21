defmodule ActivityPlannerWeb.ActivityParticipantLive.Show do
  use ActivityPlannerWeb, :live_view

  alias ActivityPlanner.Activities

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:activity_participant, Activities.get_activity_participant!(id))}
  end

  defp page_title(:show), do: "Show Activity"
  defp page_title(:edit), do: "Edit Activity"
end
