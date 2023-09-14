defmodule ActivityPlanner.Activities.Activity do
  use Ecto.Schema
  import Ecto.Changeset

  schema "activities" do
    field :title, :string
    field :end_time, :utc_datetime
    field :start_time, :utc_datetime
    field :description, :string

    belongs_to :activity_group, ActivityPlanner.Activities.ActivityGroup
    belongs_to :responsible_participant, ActivityPlanner.Participants.Participant

    timestamps()
  end

  @doc false
  def changeset(activity, attrs) do
    activity
    |> cast(attrs, [:title, :start_time, :end_time, :responsible_participant_id, :activity_group_id, :description])
    |> validate_required([:title, :start_time, :end_time, :responsible_participant_id, :activity_group_id])
  end
end
