defmodule ActivityPlannerWeb.ActivityLive.Index do
  use ActivityPlannerWeb.LiveIndex,
    key: :activity,
    context: ActivityPlanner.Activities,
    schema: ActivityPlanner.Activities.Activity,
    form: ActivityPlannerWeb.ActivityLive.FormComponent,
    assigns: [
      {:activity_groups, mod: ActivityPlanner.Activities, fun: :list_activity_groups},
      {:participants, mod: ActivityPlanner.Participants, fun: :list_participants}
    ]

  def render(assigns) do
    ~H"""
    <.header>
      Listing activities
      <:actions>
        <.link patch={~p"/activities/new"}>
          <.button>New activity</.button>
        </.link>
      </:actions>
    </.header>

    <.table
      id="activities"
      rows={@streams.activities}
      row_click={fn {_id, activity} -> JS.navigate(~p"/activities/#{activity}") end}
    >
      <:col :let={{_id, activity}} label="Description"><%= activity.description %></:col>
      <:col :let={{_id, activity}} label="Start time"><%= activity.start_time %></:col>
      <:col :let={{_id, activity}} label="End time"><%= activity.end_time %></:col>
      <:col :let={{_id, activity}} label="Responsible">
        <%= activity.responsible_participant_id %>
      </:col>
      <:col :let={{_id, activity}} label="Activity group"><%= activity.activity_group_id %></:col>
      <:action :let={{_id, activity}}>
        <div class="sr-only">
          <.link navigate={~p"/activities/#{activity}"}>Show</.link>
        </div>
        <.link patch={~p"/activities/#{activity}/edit"}>Edit</.link>
      </:action>
      <:action :let={{id, activity}}>
        <.link
          phx-click={JS.push("delete", value: %{id: activity.id}) |> hide("##{id}")}
          data-confirm="Are you sure?"
        >
          Delete
        </.link>
      </:action>
    </.table>

    <.modal
      :if={@live_action in [:new, :edit]}
      id="activity-modal"
      show
      on_cancel={JS.patch(~p"/activities")}
    >
      <.live_component
        module={ActivityPlannerWeb.ActivityLive.FormComponent}
        id={@activity.id || :new}
        title={@page_title}
        action={@live_action}
        activity={@activity}
        activity_groups={@activity_groups}
        participants={@participants}
        patch={~p"/activities"}
      />
    </.modal>
    """
  end
end
