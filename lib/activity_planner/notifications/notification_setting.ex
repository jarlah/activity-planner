defmodule ActivityPlanner.Notifications.NotificationSetting do
  use Ecto.Schema
  import Ecto.Changeset

  schema "notification_settings" do
    belongs_to :activity_group, ActivityPlanner.Activities.ActivityGroup
    belongs_to :day_in_advance_template, ActivityPlanner.Notifications.NotificationTemplate

    timestamps()
  end

  @doc false
  def changeset(notification_setting, attrs) do
    notification_setting
    |> cast(attrs, [:day_in_advance_template_id, :activity_group_id])
    |> validate_required([:day_in_advance_template_id, :activity_group_id])
  end
end
