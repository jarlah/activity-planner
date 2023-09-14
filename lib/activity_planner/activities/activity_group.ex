defmodule ActivityPlanner.Activities.ActivityGroup do
  use Ecto.Schema
  import Ecto.Changeset

  schema "activity_groups" do
    field :description, :string
    field :name, :string
    field :company_id, :id

    timestamps()
  end

  @doc false
  def changeset(activity_group, attrs) do
    activity_group
    |> cast(attrs, [:name, :description])
    |> validate_required([:name])
  end
end
