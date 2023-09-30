defmodule ActivityPlanner.Activities.ActivityParticipant do
  alias ActivityPlanner.Companies
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
    |> Companies.common_changeset(attrs)
    |> validate_required([:activity_id, :participant_id, :company_id])
  end
end
