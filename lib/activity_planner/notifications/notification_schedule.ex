defmodule ActivityPlanner.Notifications.NotificationSchedule do
  use Ecto.Schema
  import Ecto.Changeset

  schema "notification_schedules" do
    field :name, :string
    field :medium, Ecto.Enum, values: [:sms, :email]
    field :cron_expression, Crontab.CronExpression.Ecto.Type

    belongs_to :activity_group, ActivityPlanner.Activities.ActivityGroup
    belongs_to :template, ActivityPlanner.Notifications.NotificationTemplate

    timestamps()
  end

  @doc false
  def changeset(notification_setting, attrs) do
    notification_setting
    |> cast(attrs, [:name, :medium, :cron_expression, :template_id, :activity_group_id])
    |> validate_required([:name, :medium, :cron_expression, :template_id, :activity_group_id])
  end
end
