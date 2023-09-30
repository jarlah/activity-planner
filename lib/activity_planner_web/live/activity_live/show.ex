defmodule ActivityPlannerWeb.ActivityLive.Show do
  use ActivityPlannerWeb.LiveShow,
    key: :activity,
    context: ActivityPlanner.Activities,
    assigns: [
      {:activity_groups, mod: ActivityPlanner.Activities, fun: :list_activity_groups},
      {:participants, mod: ActivityPlanner.Participants, fun: :list_participants}
    ]

  def render(assigns) do
    ~H"""
    <.header>
      Activity <%= @activity.id %>
      <:subtitle>This is a activity record from your database.</:subtitle>
      <:actions>
        <.link patch={~p"/activities/#{@activity}/show/edit"} phx-click={JS.push_focus()}>
          <.button>Edit activity</.button>
        </.link>
      </:actions>
    </.header>

    <.list>
      <:item title="Description"><%= @activity.description %></:item>
      <:item title="Start time"><%= @activity.start_time %></:item>
      <:item title="End time"><%= @activity.end_time %></:item>
    </.list>

    <.back navigate={~p"/activities"}>Back to activities</.back>

    <.modal
      :if={@live_action == :edit}
      id="activity-modal"
      show
      on_cancel={JS.patch(~p"/activities/#{@activity}")}
    >
      <.live_component
        module={ActivityPlannerWeb.ActivityLive.FormComponent}
        id={@activity.id}
        title={@page_title}
        action={@live_action}
        activity={@activity}
        activity_groups={@activity_groups}
        participants={@participants}
        patch={~p"/activities/#{@activity}"}
      />
    </.modal>
    """
  end
end
