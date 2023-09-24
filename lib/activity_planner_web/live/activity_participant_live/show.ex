defmodule ActivityPlannerWeb.ActivityParticipantLive.Show do
  alias ActivityPlanner.Activities
  alias ActivityPlanner.Participants

  use ActivityPlannerWeb.LiveShow,
    key: :activity_participant,
    context: Activities,
    assigns: [
      {:activities, mod: Activities, fun: :list_activities},
      {:participants, mod: Participants, fun: :list_participants}
    ]

  def render(assigns) do
    ~H"""
      <.header>
        Activity participant <%= @activity_participant.id %>
        <:subtitle>This is an activity participant record from your database.</:subtitle>
        <:actions>
          <.link patch={~p"/activity_participants/#{@activity_participant}/show/edit"} phx-click={JS.push_focus()}>
            <.button>Edit activity participant</.button>
          </.link>
        </:actions>
      </.header>

      <.list>
        <:item title="Activity"><%= @activity_participant.activity_id %></:item>
        <:item title="Participant"><%= @activity_participant.participant_id %></:item>
      </.list>

      <.back navigate={~p"/activity_participants"}>Back to activities</.back>

      <.modal :if={@live_action == :edit} id="activity_participant-modal" show on_cancel={JS.patch(~p"/activity_participants/#{@activity_participant}")}>
        <.live_component
          module={ActivityPlannerWeb.ActivityParticipantLive.FormComponent}
          id={@activity_participant.id}
          title={@page_title}
          action={@live_action}
          activity_participant={@activity_participant}
          activities={@activities}
          participants={@participants}
          patch={~p"/activity_participants/#{@activity_participant}"}
        />
      </.modal>
    """
  end
end
