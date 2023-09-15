defmodule ActivityPlanner.Notifications.NotificationTemplate do
  use Ecto.Schema
  import Ecto.Changeset

  schema "notification_templates" do
    field :title, :string
    field :template_content, :string

    belongs_to :activity_group, ActivityPlanner.Activities.ActivityGroup

    timestamps()
  end

  @doc false
  def changeset(notification_template, attrs) do
    notification_template
    |> cast(attrs, [:template_content, :title, :activity_group_id])
    |> validate_required([:template_content, :title, :activity_group_id])
  end
end
