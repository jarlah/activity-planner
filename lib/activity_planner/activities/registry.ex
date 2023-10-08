defmodule ActivityPlanner.Activities.Registry do
  use Ash.Registry,
    extensions: [
      Ash.Registry.ResourceValidations
    ]

  entries do
    entry ActivityPlanner.Activities.Participant
    entry ActivityPlanner.Activities.ActivityGroup
    entry ActivityPlanner.Activities.Activity
  end
end
