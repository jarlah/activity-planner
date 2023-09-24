defmodule ActivityPlannerWeb.ParticipantLive.Index do
  alias ActivityPlanner.Participants
  alias ActivityPlanner.Participants.Participant

  use ActivityPlannerWeb.LiveIndex,
    key: :participant,
    context: Participants,
    schema: Participant,
    form: ActivityPlannerWeb.ParticipantLive.FormComponent
end
