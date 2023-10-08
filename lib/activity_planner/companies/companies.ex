defmodule ActivityPlanner.Companies do
  use Ash.Api

  resources do
    registry ActivityPlanner.Companies.Registry
  end
end
