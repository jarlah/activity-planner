defmodule ActivityPlanner.Notifications.NotificationSetting do
  use Ecto.Schema
  import Ecto.Changeset

  schema "notification_settings" do
    belongs_to :day_in_advance_template, ActivityPlanner.Notifications.NotificationTemplate

    timestamps()
  end

  @doc false
  def changeset(notification_setting, attrs) do
    notification_setting
    |> cast(attrs, [:day_in_advance_template_id])
    |> validate_required([:day_in_advance_template_id])
  end
end
