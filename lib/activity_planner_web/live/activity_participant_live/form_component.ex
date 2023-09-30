defmodule ActivityPlannerWeb.ActivityParticipantLive.FormComponent do
  require ActivityPlanner.Activities
  alias ActivityPlanner.Activities

  use ActivityPlannerWeb.FormComponent,
    key: :activity_participant,
    context: Activities

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
        id="activity-participant-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input
          field={@form[:activity_id]}
          type="select"
          label="Activity"
          options={
            @activities
            |> Enum.map(fn c -> {c.description || c.title || c.id, c.id} end)
          }
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
end
