defmodule ActivityPlannerWeb.ActivityGroupLive.Show do
  use ActivityPlannerWeb.LiveShow,
    key: :activity_group,
    context: ActivityPlanner.Activities

  def render(assigns) do
    ~H"""
    <.header>
      Activity group <%= @activity_group.id %>
      <:subtitle>This is a activity group record from your database.</:subtitle>
      <:actions>
        <.link patch={~p"/activity_groups/#{@activity_group}/show/edit"} phx-click={JS.push_focus()}>
          <.button>Edit activity group</.button>
        </.link>
      </:actions>
    </.header>

    <.list>
      <:item title="Name"><%= @activity_group.name %></:item>
      <:item title="Description"><%= @activity_group.description %></:item>
    </.list>

    <.back navigate={~p"/activity_groups"}>Back to activity groups</.back>

    <.modal
      :if={@live_action == :edit}
      id="activity-modal"
      show
      on_cancel={JS.patch(~p"/activity_groups/#{@activity_group}")}
    >
      <.live_component
        module={ActivityPlannerWeb.ActivityGroupLive.FormComponent}
        id={@activity_group.id}
        title={@page_title}
        action={@live_action}
        activity_group={@activity_group}
        patch={~p"/activity_groups/#{@activity_group}"}
      />
    </.modal>
    """
  end
end
