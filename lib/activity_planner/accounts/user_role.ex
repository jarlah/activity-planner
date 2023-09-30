defmodule ActivityPlanner.Accounts.UserRole do
  use ActivityPlanner.Schema

  schema "user_roles" do
    field :role, :string

    belongs_to :company, ActivityPlanner.Companies.Company, references: :company_id
    belongs_to :user, ActivityPlanner.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(user_role, attrs) do
    user_role
    |> cast(attrs, [:role, :user_id, :company_id])
    |> validate_required([:role, :user_id, :company_id])
  end
end
