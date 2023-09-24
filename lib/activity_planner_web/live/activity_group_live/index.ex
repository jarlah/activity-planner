defmodule ActivityPlannerWeb.ActivityGroupLive.Index do
  alias ActivityPlanner.Activities
  alias ActivityPlanner.Activities.ActivityGroup

  use ActivityPlannerWeb.LiveIndex,
    key: :activity_group,
    context: Activities,
    schema: ActivityGroup,
    form: ActivityPlannerWeb.ActivityGroupLive.FormComponent
end
