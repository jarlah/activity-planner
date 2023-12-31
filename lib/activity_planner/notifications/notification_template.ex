defmodule ActivityPlanner.Notifications.NotificationTemplate do
  alias ActivityPlanner.Companies
  use ActivityPlanner.Schema

  schema "notification_templates" do
    field :title, :string
    field :template_content, :string

    belongs_to :company, ActivityPlanner.Companies.Company, references: :company_id

    timestamps()
  end

  @doc false
  def changeset(notification_template, attrs, opts \\ []) do
    notification_template
    |> cast(attrs, [:template_content, :title])
    |> Companies.common_changeset(attrs, opts)
    |> validate_required([:template_content, :title, :company_id])
  end
end
