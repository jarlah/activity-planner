defmodule ActivityPlanner.Accounts.Token do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshAuthentication.TokenResource]

  token do
    api ActivityPlanner.Accounts
  end

  postgres do
    table "tokens"
    repo ActivityPlanner.Repo
  end
end
