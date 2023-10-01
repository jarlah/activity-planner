defmodule ActivityPlannerWeb.NotificationScheduleLive.Show do
  use ActivityPlannerWeb.LiveShow,
    key: :notification_schedule,
    context: ActivityPlanner.Notifications,
    assigns: [
      {:activity_groups, mod: ActivityPlanner.Activities, fun: :list_activity_groups},
      {:templates, mod: ActivityPlanner.Notifications, fun: :list_notification_templates}
    ]

  def render(assigns) do
    ~H"""
    <.header>
      Notification schedule <%= @notification_schedule.id %>
      <:subtitle>This is a notification schedule record from your database.</:subtitle>
      <:actions>
        <.link
          patch={~p"/notification_schedules/#{@notification_schedule}/show/edit"}
          phx-click={JS.push_focus()}
        >
          <.button>Edit notification schedule</.button>
        </.link>
      </:actions>
    </.header>

    <.list>
      <:item title="Name"><%= @notification_schedule.name %></:item>
      <:item title="Medium"><%= @notification_schedule.medium %></:item>
    </.list>

    <.back navigate={~p"/notification_schedules"}>Back to notification schedules</.back>

    <.modal
      :if={@live_action == :edit}
      id="notification-schedule-modal"
      show
      on_cancel={JS.patch(~p"/notification_schedules/#{@notification_schedule}")}
    >
      <.live_component
        module={ActivityPlannerWeb.NotificationScheduleLive.FormComponent}
        id={@notification_schedule.id}
        title={@page_title}
        action={@live_action}
        notification_schedule={@notification_schedule}
        activity_groups={@activity_groups}
        templates={@templates}
        patch={~p"/notification_schedules/#{@notification_schedule}"}
      />
    </.modal>
    """
  end
end
