defmodule ActivityPlanner.Activities do
  use Ash.Api

  resources do
    registry ActivityPlanner.Activities.Registry
  end
end
