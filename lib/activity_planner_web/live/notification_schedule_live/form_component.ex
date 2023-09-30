defmodule ActivityPlannerWeb.NotificationScheduleLive.FormComponent do
  use ActivityPlannerWeb.FormComponent,
    key: :notification_schedule,
    context: ActivityPlanner.Notifications

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage notification schedule records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="notification-schedule-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:medium]} type="text" label="Medium" />
        <.input field={@form[:cron_expression]} type="text" label="Cron expression" />
        <.input field={@form[:enabled]} type="checkbox" label="Enabled" />
        <.input field={@form[:hours_window_offset]} type="number" label="Hours offset" />
        <.input field={@form[:hours_window_length]} type="number" label="Hours length" />
        <.input
          field={@form[:activity_group_id]}
          type="select"
          label="Activity"
          options={
            @activity_groups
            |> Enum.map(fn c -> {c.name || c.id, c.id} end)
          }
          prompt="Select activity"
        />
        <.input
          field={@form[:template_id]}
          type="select"
          label="Template"
          options={
            @templates
            |> Enum.map(fn c -> {c.title || c.id, c.id} end)
          }
          prompt="Select template"
        />
        <:actions>
          <.button phx-disable-with="Saving...">Save notification schedule</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end
end
