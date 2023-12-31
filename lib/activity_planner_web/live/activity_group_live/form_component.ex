defmodule ActivityPlannerWeb.ActivityGroupLive.FormComponent do
  use ActivityPlannerWeb.FormComponent,
    key: :activity_group,
    context: ActivityPlanner.Activities

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
        id="activity-group-form"
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
end
