defmodule ActivityPlanner.Notifications.NotificationTemplate do
  use Ecto.Schema
  import Ecto.Changeset

  schema "notification_templates" do
    field :title, :string
    field :template_content, :string

    belongs_to :company, ActivityPlanner.Companies.Company, references: :company_id

    timestamps()
  end

  @doc false
  def changeset(notification_template, attrs) do
    notification_template
    |> cast(attrs, [:template_content, :title, :company_id])
    |> validate_required([:template_content, :title, :company_id])
  end
end
