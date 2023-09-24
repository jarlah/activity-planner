defmodule ActivityPlannerWeb.ParticipantLive.Index do
  alias ActivityPlanner.Participants
  alias ActivityPlanner.Participants.Participant
  alias ActivityPlannerWeb.ParticipantLive.FormComponent

  use ActivityPlannerWeb.LiveIndex,
    key: :participant,
    context: Participants,
    schema: Participant,
    form: FormComponent

  def render(assigns) do
    ~H"""
      <.header>
        Listing participants
        <:actions>
          <.link patch={~p"/participants/new"}>
            <.button>New participant</.button>
          </.link>
        </:actions>
      </.header>

      <.table
        id="activities"
        rows={@streams.participants}
        row_click={fn {_id, participant} -> JS.navigate(~p"/participants/#{participant}") end}
      >
        <:col :let={{_id, participant}} label="Name"><%= participant.name %></:col>
        <:col :let={{_id, participant}} label="Phone"><%= participant.phone %></:col>
        <:col :let={{_id, participant}} label="Email"><%= participant.email %></:col>
        <:action :let={{_id, participant}}>
          <div class="sr-only">
            <.link navigate={~p"/participants/#{participant}"}>Show</.link>
          </div>
          <.link patch={~p"/participants/#{participant}/edit"}>Edit</.link>
        </:action>
        <:action :let={{id, participant}}>
          <.link
            phx-click={JS.push("delete", value: %{id: participant.id}) |> hide("##{id}")}
            data-confirm="Are you sure?"
          >
            Delete
          </.link>
        </:action>
      </.table>

      <.modal :if={@live_action in [:new, :edit]} id="participant-modal" show on_cancel={JS.patch(~p"/participants")}>
        <.live_component
          module={FormComponent}
          id={@participant.id || :new}
          title={@page_title}
          action={@live_action}
          participant={@participant}
          patch={~p"/participants"}
        />
      </.modal>
    """
  end
end
