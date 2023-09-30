defmodule ActivityPlanner.Activities.Activity do
  alias ActivityPlanner.Companies
  use ActivityPlanner.Schema

  schema "activities" do
    field :title, :string
    field :description, :string
    field :start_time, :utc_datetime
    field :end_time, :utc_datetime

    belongs_to :company, ActivityPlanner.Companies.Company, references: :company_id
    belongs_to :activity_group, ActivityPlanner.Activities.ActivityGroup
    belongs_to :responsible_participant, ActivityPlanner.Participants.Participant

    many_to_many :participants, ActivityPlanner.Participants.Participant,
      join_through: "activity_participants"

    timestamps()
  end

  @doc false
  def changeset(activity, attrs, opts \\ []) do
    activity
    |> cast(attrs, [
      :responsible_participant_id,
      :activity_group_id,
      :description,
      :start_time,
      :end_time
    ])
    |> Companies.common_changeset(attrs, opts)
    |> validate_required([
      :responsible_participant_id,
      :activity_group_id,
      :company_id,
      :start_time,
      :end_time
    ])
  end
end
