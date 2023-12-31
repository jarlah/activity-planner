defmodule ActivityPlannerWeb.ActivityParticipantLive.Index do
  use ActivityPlannerWeb.LiveIndex,
    key: :activity_participant,
    context: ActivityPlanner.Activities,
    schema: ActivityPlanner.Activities.ActivityParticipant,
    form: ActivityPlannerWeb.ActivityParticipantLive.FormComponent,
    assigns: [
      {:activities, mod: ActivityPlanner.Activities, fun: :list_activities},
      {:participants, mod: ActivityPlanner.Participants, fun: :list_participants}
    ]

  def render(assigns) do
    ~H"""
    <.header>
      Listing activity participants
      <:actions>
        <.link patch={~p"/activity_participants/new"}>
          <.button>New activity participant</.button>
        </.link>
      </:actions>
    </.header>

    <.table
      id="activities"
      rows={@streams.activity_participants}
      row_click={
        fn {_id, activity_participant} ->
          JS.navigate(~p"/activity_participants/#{activity_participant}")
        end
      }
    >
      <:col :let={{_id, activity_participant}} label="Activity">
        <%= activity_participant.activity_id %>
      </:col>
      <:col :let={{_id, activity_participant}} label="Participant">
        <%= activity_participant.participant_id %>
      </:col>
      <:action :let={{_id, activity_participant}}>
        <div class="sr-only">
          <.link navigate={~p"/activity_participants/#{activity_participant}"}>Show</.link>
        </div>
        <.link patch={~p"/activity_participants/#{activity_participant}/edit"}>Edit</.link>
      </:action>
      <:action :let={{id, activity_participant}}>
        <.link
          phx-click={JS.push("delete", value: %{id: activity_participant.id}) |> hide("##{id}")}
          data-confirm="Are you sure?"
        >
          Delete
        </.link>
      </:action>
    </.table>

    <.modal
      :if={@live_action in [:new, :edit]}
      id="activity_participant-modal"
      show
      on_cancel={JS.patch(~p"/activity_participants")}
    >
      <.live_component
        module={ActivityPlannerWeb.ActivityParticipantLive.FormComponent}
        id={@activity_participant.id || :new}
        title={@page_title}
        action={@live_action}
        activity_participant={@activity_participant}
        activities={@activities}
        participants={@participants}
        patch={~p"/activity_participants"}
      />
    </.modal>
    """
  end
end
