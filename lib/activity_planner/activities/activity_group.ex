defmodule ActivityPlanner.Activities.ActivityGroup do
  use Ecto.Schema
  import Ecto.Changeset

  schema "activity_groups" do
    field :name, :string
    field :description, :string

    belongs_to :company, ActivityPlanner.Companies.Company, references: :company_id
    has_many :activities, ActivityPlanner.Activities.Activity

    timestamps()
  end

  @doc false
  def changeset(activity_group, attrs) do
    activity_group
    |> cast(attrs, [:name, :description, :company_id])
    |> validate_required([:name, :company_id])
  end
end
