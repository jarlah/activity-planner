defmodule ActivityPlanner.Companies.Company do
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
    table "companies"
    repo ActivityPlanner.Repo
  end
end
