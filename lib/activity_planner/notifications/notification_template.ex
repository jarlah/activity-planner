defmodule ActivityPlanner.Notifications.NotificationTemplate do
  use Ecto.Schema
  import Ecto.Changeset

  schema "notification_templates" do
    field :template_content, :string
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(notification_template, attrs) do
    notification_template
    |> cast(attrs, [:template_content, :title])
    |> validate_required([:template_content, :title])
  end
end
