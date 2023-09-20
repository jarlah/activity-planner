defmodule ActivityPlanner.Activities.Activity do
  use Ecto.Schema
  import Ecto.Changeset

  schema "activities" do
    field :description, :string
    field :start_time, :utc_datetime
    field :end_time, :utc_datetime
    field :company_id, :integer

    belongs_to :activity_group, ActivityPlanner.Activities.ActivityGroup
    belongs_to :responsible_participant, ActivityPlanner.Participants.Participant
    many_to_many :participants, ActivityPlanner.Participants.Participant, join_through: "activity_participants"

    timestamps()
  end

  @doc false
  def changeset(activity, attrs) do
    activity
    |> cast(attrs, [:responsible_participant_id, :activity_group_id, :company_id, :description, :start_time, :end_time])
    |> validate_required([:responsible_participant_id, :activity_group_id, :company_id, :start_time, :end_time])
  end
end
