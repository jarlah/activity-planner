defmodule ActivityPlannerWeb.ParticipantLive.FormComponent do
  alias ActivityPlanner.Participants

  use ActivityPlannerWeb.FormComponent,
    key: :participant,
    context: Participants

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage participant records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="activity-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:phone]} type="text" label="Phone" />
        <.input field={@form[:email]} type="text" label="Email" />
        <:actions>
          <.button phx-disable-with="Saving...">Save participant</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end
end
