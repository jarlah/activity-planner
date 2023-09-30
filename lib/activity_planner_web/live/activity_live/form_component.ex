defmodule ActivityPlannerWeb.ActivityLive.FormComponent do
  use ActivityPlannerWeb.FormComponent,
    key: :activity,
    context: ActivityPlanner.Activities

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage activity records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="activity-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:description]} type="text" label="Description" />
        <.input field={@form[:start_time]} type="datetime-local" label="Start time" />
        <.input field={@form[:end_time]} type="datetime-local" label="End time" />
        <.input
          field={@form[:activity_group_id]}
          type="select"
          label="Activity Group"
          options={@activity_groups |> Enum.map(fn c -> {c.name, c.id} end)}
          prompt="Select activity group"
        />
        <.link navigate={~p"/activity_groups/new"}>New activity group</.link>
        <.input
          field={@form[:responsible_participant_id]}
          type="select"
          label="Responsible participant"
          options={@participants |> Enum.map(fn c -> {c.name, c.id} end)}
          prompt="Select participant"
        />
        <.link navigate={~p"/participants/new"}>New participant</.link>
        <:actions>
          <.button phx-disable-with="Saving...">Save Activity</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end
end
