defmodule ActivityPlanner.Notifications.NotificationSchedule do
  use Ecto.Schema
  import Ecto.Changeset

  schema "notification_schedules" do
    field :name, :string
    field :medium, Ecto.Enum, values: [:sms, :email]
    field :cron_expression, Crontab.CronExpression.Ecto.Type
    field :hours_window_offset, :integer, default: 0
    field :hours_window_length, :integer
    field :enabled, :boolean
    field :company_id, :integer

    belongs_to :activity_group, ActivityPlanner.Activities.ActivityGroup
    belongs_to :template, ActivityPlanner.Notifications.NotificationTemplate

    timestamps()
  end

  @doc false
  def changeset(notification_setting, attrs) do
    notification_setting
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
    |> validate_required([
      :name,
      :medium,
      :cron_expression,
      :template_id,
      :activity_group_id,
      :hours_window_offset,
      :hours_window_length,
      :enabled
    ])
  end
end
