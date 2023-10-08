defmodule ActivityPlanner.Accounts.User do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshAuthentication]

  attributes do
    uuid_primary_key :id
    attribute :email, :ci_string, allow_nil?: false
    attribute :hashed_password, :string, allow_nil?: false, sensitive?: true
    attribute :confirmed_at, :utc_datetime_usec, allow_nil?: true
  end

  authentication do
    api ActivityPlanner.Accounts

    strategies do
      password :password do
        identity_field :email
        hashed_password_field :hashed_password
      end
    end

    tokens do
      enabled? true
      token_resource ActivityPlanner.Accounts.Token
      signing_secret ActivityPlanner.Accounts.Secrets
    end
  end

  postgres do
    table "users"
    repo ActivityPlanner.Repo
  end

  identities do
    identity :unique_email, [:email]
  end
end
