defmodule ActivityPlanner.Activities.Activity do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer

  attributes do
    uuid_primary_key :id
    attribute :title, :string do
      allow_nil? false
    end
    attribute :description, :string
    attribute :start_time, :utc_datetime_usec do
      allow_nil? false
    end
    attribute :end_time, :utc_datetime_usec do
      allow_nil? false
    end
  end

  postgres do
    table "activity_groups"
    repo ActivityPlanner.Repo
  end

  relationships do
    belongs_to :responsible_participant, ActivityPlanner.Activities.Participant
    belongs_to :activity_group, ActivityPlanner.Activities.ActivityGroup
    belongs_to :company, ActivityPlanner.Companies.Company do
      api ActivityPlanner.Companies
    end
  end
end
