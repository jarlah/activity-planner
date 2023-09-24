defmodule ActivityPlannerWeb.ActivityParticipantLive.Index do
  alias ActivityPlanner.Activities
  alias ActivityPlanner.Activities.ActivityParticipant
  alias ActivityPlanner.Participants

  use ActivityPlannerWeb.LiveIndex,
    key: :activity_participant,
    context: Activities,
    schema: ActivityParticipant,
    form: ActivityPlannerWeb.ActivityParticipantLive.FormComponent,
    assigns: [
      {:activities, mod: Activities, fun: :list_activities},
      {:participants, mod: Participants, fun: :list_participants}
    ]
end
