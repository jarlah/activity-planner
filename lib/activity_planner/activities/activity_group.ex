defmodule ActivityPlanner.Activities.ActivityGroup do
  alias ActivityPlanner.Companies
  use ActivityPlanner.Schema

  schema "activity_groups" do
    field :name, :string
    field :description, :string

    belongs_to :company, ActivityPlanner.Companies.Company, references: :company_id
    has_many :activities, ActivityPlanner.Activities.Activity

    timestamps()
  end

  @doc false
  def changeset(activity_group, attrs, opts \\ []) do
    activity_group
    |> cast(attrs, [:name, :description])
    |> Companies.common_changeset(attrs, opts)
    |> validate_required([:name, :company_id])
  end
end
