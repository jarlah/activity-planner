defmodule ActivityPlanner.Accounts do
  use Ash.Api

  resources do
    registry ActivityPlanner.Accounts.Registry
  end
end
