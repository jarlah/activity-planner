defmodule ActivityPlannerWeb.ActivityParticipantLive.FormComponent do
  use ActivityPlannerWeb, :live_component

  alias ActivityPlanner.Activities

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage activity_participant records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="activity_participant-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input
          field={@form[:activity_id]}
          type="select"
          label="Activity"
          options={@activities |> Enum.map(fn c -> {c.description || c.name, c.id} end)}
          prompt="Select activity"
        />
        <.input
          field={@form[:participant_id]}
          type="select"
          label="Participant"
          options={@participants |> Enum.map(fn c -> {c.name, c.id} end)}
          prompt="Select participant"
        />
        <:actions>
          <.button phx-disable-with="Saving...">Save Activity</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{activity_participant: activity_participant} = assigns, socket) do
    changeset = Activities.change_activity_participant(activity_participant)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"activity_participant" => activity_participant_params}, socket) do
    changeset =
      socket.assigns.activity_participant
      |> Activities.change_activity_participant(activity_participant_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"activity_participant" => activity_participant_params}, socket) do
    save_activity_participant(socket, socket.assigns.action, activity_participant_params)
  end

  defp save_activity_participant(socket, :edit, activity_participant_params) do
    case Activities.update_activity_participant(socket.assigns.activity_participant, activity_participant_params) do
      {:ok, activity_participant} ->
        notify_parent({:saved, activity_participant})

        {:noreply,
         socket
         |> put_flash(:info, "Activity participant updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_activity_participant(socket, :new, activity_participant_params) do
    case Activities.create_activity_participant(activity_participant_params) do
      {:ok, activity_participant} ->
        notify_parent({:saved, activity_participant})

        {:noreply,
         socket
         |> put_flash(:info, "Activity participant created successfully")
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
