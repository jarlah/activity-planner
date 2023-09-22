defmodule ActivityPlannerWeb.NotificationTemplateLive.Show do
  use ActivityPlannerWeb, :live_view

  alias ActivityPlanner.Notifications

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:notification_template, Notifications.get_notification_template!(id))}
  end

  defp page_title(:show), do: "Show notification template"
  defp page_title(:edit), do: "Edit notification template"
end
