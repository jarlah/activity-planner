defmodule ActivityPlannerWeb.ParticipantLive.Show do
  require ActivityPlanner.Participants
  alias ActivityPlanner.Participants
  alias ActivityPlannerWeb.ParticipantLive.FormComponent

  use ActivityPlannerWeb.LiveShow,
    key: :participant,
    context: Participants

  def render(assigns) do
    ~H"""
    <.header>
      Participant <%= @participant.id %>
      <:subtitle>This is a participant record from your database.</:subtitle>
      <:actions>
        <.link patch={~p"/participants/#{@participant}/show/edit"} phx-click={JS.push_focus()}>
          <.button>Edit participant</.button>
        </.link>
      </:actions>
    </.header>

    <.list>
      <:item title="Name"><%= @participant.name %></:item>
      <:item title="Phone"><%= @participant.phone %></:item>
      <:item title="Email"><%= @participant.email %></:item>
    </.list>

    <.back navigate={~p"/participants"}>Back to participants</.back>

    <.modal
      :if={@live_action == :edit}
      id="participant-modal"
      show
      on_cancel={JS.patch(~p"/participants/#{@participant}")}
    >
      <.live_component
        module={FormComponent}
        id={@participant.id}
        title={@page_title}
        action={@live_action}
        participant={@participant}
        patch={~p"/participants/#{@participant}"}
      />
    </.modal>
    """
  end
end
