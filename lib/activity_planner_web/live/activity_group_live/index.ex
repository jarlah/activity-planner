defmodule ActivityPlannerWeb.ActivityGroupLive.Index do
  alias ActivityPlanner.Activities.ActivityGroup
  use ActivityPlannerWeb, :live_view

  alias ActivityPlanner.Activities

  @impl true
  def mount(_params, _session, socket) do
    {
      :ok,
      socket
      |> stream(:activity_groups, Activities.list_activity_groups())
    }
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit activity group")
    |> assign(:activity_group, Activities.get_activity_group!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New activity group")
    |> assign(:activity_group, %ActivityGroup{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing activity groups")
    |> assign(:activity_group, nil)
  end

  @impl true
  def handle_info({ActivityPlannerWeb.ActivityGroupLive.FormComponent, {:saved, activity}}, socket) do
    {:noreply, stream_insert(socket, :activity_groups, activity)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    activity = Activities.get_activity_group!(id)
    {:ok, _} = Activities.delete_activity_group(activity)

    {:noreply, stream_delete(socket, :activity_groups, activity) |> put_flash(:info, "Activity group deleted successfully")  }
  end
end
