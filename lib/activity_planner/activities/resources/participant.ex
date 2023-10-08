defmodule ActivityPlanner.Activities.Participant do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer

  attributes do
    uuid_primary_key :id
    attribute :name, :string do
      allow_nil? false
    end
    attribute :phone, :string do
      allow_nil? false
    end
    attribute :email, :string do
      allow_nil? false
    end
  end

  postgres do
    table "participants"
    repo ActivityPlanner.Repo
  end

  identities do
    identity :unique_email, [:email]
    identity :unique_phone, [:phone]
  end

  relationships do
    belongs_to :company, ActivityPlanner.Companies.Company do
      api ActivityPlanner.Companies
    end
  end
end
