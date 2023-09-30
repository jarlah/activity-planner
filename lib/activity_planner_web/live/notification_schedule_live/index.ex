defmodule ActivityPlannerWeb.NotificationScheduleLive.Index do
  use ActivityPlannerWeb.LiveIndex,
    key: :notification_schedule,
    context: ActivityPlanner.Notifications,
    schema: ActivityPlanner.Notifications.NotificationSchedule,
    form: ActivityPlannerWeb.NotificationScheduleLive.FormComponent,
    assigns: [
      {:activity_groups, mod: ActivityPlanner.Activities, fun: :list_activity_groups},
      {:templates, mod: ActivityPlanner.Notifications, fun: :list_notification_templates}
    ]

  def render(assigns) do
    ~H"""
    <.header>
      Listing notification schedules
      <:actions>
        <.link patch={~p"/notification_schedules/new"}>
          <.button>New notification schedule</.button>
        </.link>
      </:actions>
    </.header>

    <.table
      id="notification-schedules"
      rows={@streams.notification_schedules}
      row_click={
        fn {_id, notification_schedule} ->
          JS.navigate(~p"/notification_schedules/#{notification_schedule}")
        end
      }
    >
      <:col :let={{_id, notification_schedule}} label="Activity">
        <%= notification_schedule.name %>
      </:col>
      <:col :let={{_id, notification_schedule}} label="Participant">
        <%= notification_schedule.medium %>
      </:col>
      <:action :let={{_id, notification_schedule}}>
        <div class="sr-only">
          <.link navigate={~p"/notification_schedules/#{notification_schedule}"}>Show</.link>
        </div>
        <.link patch={~p"/notification_schedules/#{notification_schedule}/edit"}>Edit</.link>
      </:action>
      <:action :let={{id, notification_schedule}}>
        <.link
          phx-click={JS.push("delete", value: %{id: notification_schedule.id}) |> hide("##{id}")}
          data-confirm="Are you sure?"
        >
          Delete
        </.link>
      </:action>
    </.table>

    <.modal
      :if={@live_action in [:new, :edit]}
      id="notification-schedule-modal"
      show
      on_cancel={JS.patch(~p"/notification_schedules")}
    >
      <.live_component
        module={ActivityPlannerWeb.NotificationScheduleLive.FormComponent}
        id={@notification_schedule.id || :new}
        title={@page_title}
        action={@live_action}
        notification_schedule={@notification_schedule}
        activity_groups={@activity_groups}
        templates={@templates}
        patch={~p"/notification_schedules"}
      />
    </.modal>
    """
  end
end
