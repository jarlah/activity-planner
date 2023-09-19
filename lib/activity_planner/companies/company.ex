defmodule ActivityPlanner.Companies.Company do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:company_id, :id, autogenerate: true}
  schema "companies" do
    field :address, :string
    field :description, :string
    field :name, :string

    has_many :activity_groups, ActivityPlanner.Activities.ActivityGroup, foreign_key: :company_id

    timestamps()
  end

  @doc false
  def changeset(company, attrs) do
    company
    |> cast(attrs, [:name, :address, :description])
    |> validate_required([:name, :address])
  end
end
