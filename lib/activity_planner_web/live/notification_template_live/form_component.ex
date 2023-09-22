defmodule ActivityPlannerWeb.NotificationTemplateLive.FormComponent do
  use ActivityPlannerWeb, :live_component

  alias ActivityPlanner.Notifications

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage notification template records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="notification-template-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:title]} type="text" label="Title" />
        <.input field={@form[:template_content]} type="textarea" rows={10} label="Content" />
        <:actions>
          <.button phx-disable-with="Saving...">Save notification template</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{notification_template: notification_template} = assigns, socket) do
    changeset = Notifications.change_notification_template(notification_template)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"notification_template" => notification_template_params}, socket) do
    changeset =
      socket.assigns.notification_template
      |> Notifications.change_notification_template(notification_template_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"notification_template" => notification_template_params}, socket) do
    save_notification_template(socket, socket.assigns.action, notification_template_params)
  end

  defp save_notification_template(socket, :edit, notification_template_params) do
    case Notifications.update_notification_template(socket.assigns.notification_template, notification_template_params) do
      {:ok, notification_template} ->
        notify_parent({:saved, notification_template})

        {:noreply,
         socket
         |> put_flash(:info, "Notification template updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_notification_template(socket, :new, notification_template_params) do
    case Notifications.create_notification_template(notification_template_params) do
      {:ok, notification_template} ->
        notify_parent({:saved, notification_template})

        {:noreply,
         socket
         |> put_flash(:info, "Notification template created successfully")
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
