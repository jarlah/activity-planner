defmodule ActivityPlanner.Accounts.Registry do
  use Ash.Registry,
    extensions: [
      Ash.Registry.ResourceValidations
    ]

  entries do
    entry ActivityPlanner.Accounts.User
    entry ActivityPlanner.Accounts.Token
  end
end
