defmodule ActivityPlanner.Notifications.NotificationSchedule do
  use ActivityPlanner.Schema
  alias ActivityPlanner.Companies

  schema "notification_schedules" do
    field :name, :string
    field :medium, Ecto.Enum, values: [:sms, :email]
    field :cron_expression, Crontab.CronExpression.Ecto.Type
    field :hours_window_offset, :integer, default: 0
    field :hours_window_length, :integer
    field :enabled, :boolean

    belongs_to :company, ActivityPlanner.Companies.Company, references: :company_id
    belongs_to :activity_group, ActivityPlanner.Activities.ActivityGroup
    belongs_to :template, ActivityPlanner.Notifications.NotificationTemplate

    timestamps()
  end

  @doc false
  def changeset(notification_schedule, attrs, opts \\ []) do
    notification_schedule
    |> cast(attrs, [
      :name,
      :medium,
      :cron_expression,
      :template_id,
      :activity_group_id,
      :hours_window_offset,
      :hours_window_length,
      :enabled
    ])
    |> Companies.common_changeset(attrs, opts)
    |> validate_required([
      :name,
      :medium,
      :cron_expression,
      :template_id,
      :activity_group_id,
      :hours_window_offset,
      :hours_window_length,
      :enabled,
      :company_id
    ])
  end
end
