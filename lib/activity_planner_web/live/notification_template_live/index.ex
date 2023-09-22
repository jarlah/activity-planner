defmodule ActivityPlannerWeb.NotificationTemplateLive.Index do
  alias ActivityPlanner.Notifications.NotificationTemplate
  use ActivityPlannerWeb, :live_view

  alias ActivityPlanner.Notifications

  @impl true
  def mount(_params, _session, socket) do
    {
      :ok,
      socket
      |> stream(:notification_templates, Notifications.list_notification_templates())
    }
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit notification template")
    |> assign(:notification_template, Notifications.get_notification_template!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New notification template")
    |> assign(:notification_template, %NotificationTemplate{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing notification templates")
    |> assign(:notification_template, nil)
  end

  @impl true
  def handle_info({ActivityPlannerWeb.NotificationTemplateLive.FormComponent, {:saved, notification_template}}, socket) do
    {:noreply, stream_insert(socket, :notification_templates, notification_template)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    notification_template = Notifications.get_notification_template!(id)
    {:ok, _} = Notifications.delete_notification_template(notification_template)

    {:noreply, stream_delete(socket, :notification_templates, notification_template) |> put_flash(:info, "Notification template deleted successfully") }
  end
end
