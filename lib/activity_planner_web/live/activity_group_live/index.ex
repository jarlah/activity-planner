defmodule ActivityPlannerWeb.ActivityGroupLive.Index do
  use ActivityPlannerWeb.LiveIndex,
    key: :activity_group,
    context: ActivityPlanner.Activities,
    schema: ActivityPlanner.Activities.ActivityGroup,
    form: ActivityPlannerWeb.ActivityGroupLive.FormComponent

  def render(assigns) do
    ~H"""
    <.header>
      Listing activity groups
      <:actions>
        <.link patch={~p"/activity_groups/new"}>
          <.button>New activity group</.button>
        </.link>
      </:actions>
    </.header>

    <.table
      id="activities"
      rows={@streams.activity_groups}
      row_click={fn {_id, activity_group} -> JS.navigate(~p"/activity_groups/#{activity_group}") end}
    >
      <:col :let={{_id, activity_group}} label="Name"><%= activity_group.name %></:col>
      <:col :let={{_id, activity_group}} label="Description"><%= activity_group.description %></:col>
      <:action :let={{_id, activity_group}}>
        <div class="sr-only">
          <.link navigate={~p"/activity_groups/#{activity_group}"}>Show</.link>
        </div>
        <.link patch={~p"/activity_groups/#{activity_group}/edit"}>Edit</.link>
      </:action>
      <:action :let={{id, activity_group}}>
        <.link
          phx-click={JS.push("delete", value: %{id: activity_group.id}) |> hide("##{id}")}
          data-confirm="Are you sure?"
        >
          Delete
        </.link>
      </:action>
    </.table>

    <.modal
      :if={@live_action in [:new, :edit]}
      id="activity-group-modal"
      show
      on_cancel={JS.patch(~p"/activity_groups")}
    >
      <.live_component
        module={ActivityPlannerWeb.ActivityGroupLive.FormComponent}
        id={@activity_group.id || :new}
        title={@page_title}
        action={@live_action}
        activity_group={@activity_group}
        patch={~p"/activity_groups"}
      />
    </.modal>
    """
  end
end
