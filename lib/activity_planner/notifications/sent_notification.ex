defmodule ActivityPlanner.Notifications.SentNotification do
  use ActivityPlanner.Schema
  alias ActivityPlanner.Companies

  schema "sent_notifications" do
    field :sent_at, :utc_datetime
    field :status, :string
    field :medium, :string
    field :receiver, :string
    field :actual_content, :string
    field :actual_title, :string

    belongs_to :company, ActivityPlanner.Companies.Company, references: :company_id
    belongs_to :activity, ActivityPlanner.Activities.Activity

    timestamps()
  end

  @doc false
  def changeset(sent_notification, attrs, opts \\ []) do
    sent_notification
    |> cast(attrs, [
      :sent_at,
      :status,
      :medium,
      :receiver,
      :actual_content,
      :actual_title,
      :activity_id
    ])
    |> Companies.common_changeset(attrs, opts)
    |> validate_required([
      :sent_at,
      :status,
      :medium,
      :receiver,
      :actual_content,
      :actual_title,
      :activity_id,
      :company_id
    ])
  end
end
