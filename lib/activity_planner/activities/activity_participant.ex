defmodule ActivityPlanner.Activities.ActivityParticipant do
  use Ecto.Schema
  import Ecto.Changeset

  schema "activity_participants" do

    belongs_to :activity, ActivityPlanner.Activities.Activity
    belongs_to :participant, ActivityPlanner.Participants.Participant

    timestamps()
  end

  @doc false
  def changeset(activity_participant, attrs) do
    activity_participant
    |> cast(attrs, [:activity_id, :participant_id])
    |> validate_required([:activity_id, :participant_id])
  end
end