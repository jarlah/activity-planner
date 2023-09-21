defmodule ActivityPlannerWeb.ActivityGroupLive.FormComponent do
  use ActivityPlannerWeb, :live_component

  alias ActivityPlanner.Activities

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage activity group records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="activity-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:description]} type="text" label="Description" />
        <:actions>
          <.button phx-disable-with="Saving...">Save activity group</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{activity_group: activity_group} = assigns, socket) do
    changeset = Activities.change_activity_group(activity_group)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"activity_group" => activity_group_params}, socket) do
    changeset =
      socket.assigns.activity_group
      |> Activities.change_activity_group(activity_group_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"activity_group" => activity_group_params}, socket) do
    save_activity_group(socket, socket.assigns.action, activity_group_params)
  end

  defp save_activity_group(socket, :edit, activity_group_params) do
    case Activities.update_activity_group(socket.assigns.activity_group, activity_group_params) do
      {:ok, activity_group} ->
        notify_parent({:saved, activity_group})

        {:noreply,
         socket
         |> put_flash(:info, "Activity group updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_activity_group(socket, :new, activity_group_params) do
    case Activities.create_activity_group(activity_group_params) do
      {:ok, activity_group} ->
        notify_parent({:saved, activity_group})

        {:noreply,
         socket
         |> put_flash(:info, "Activity group created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
