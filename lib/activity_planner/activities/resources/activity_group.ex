defmodule ActivityPlanner.Activities.ActivityGroup do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer

  attributes do
    uuid_primary_key :id
    attribute :name, :string do
      allow_nil? false
    end
    attribute :description, :string
  end

  postgres do
    table "activity_groups"
    repo ActivityPlanner.Repo
  end

  relationships do
    belongs_to :company, ActivityPlanner.Companies.Company do
      api ActivityPlanner.Companies
    end
  end
end
