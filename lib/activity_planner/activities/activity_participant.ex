defmodule ActivityPlanner.Activities.ActivityParticipant do
  use ActivityPlanner.Schema

  schema "activity_participants" do
    belongs_to :activity, ActivityPlanner.Activities.Activity
    belongs_to :participant, ActivityPlanner.Participants.Participant
    field :company_id, :binary_id

    timestamps()
  end

  @doc false
  def changeset(activity_participant, attrs) do
    activity_participant
    |> cast(attrs, [:activity_id, :participant_id, :company_id])
    |> validate_required([:activity_id, :participant_id, :company_id])
  end
end
