defmodule ActivityPlannerWeb.ActivityLive.Index do
  alias ActivityPlanner.Participants
  alias ActivityPlanner.Activities
  alias ActivityPlanner.Activities.Activity
  alias ActivityPlannerWeb.ActivityLive.FormComponent

  use ActivityPlannerWeb.LiveIndex,
    key: :activity,
    context: Activities,
    schema: Activity,
    form: FormComponent,
    assigns: [
      {:activity_groups, mod: Activities, fun: :list_activity_groups},
      {:participants, mod: Participants, fun: :list_participants}
    ]
end
