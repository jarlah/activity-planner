defmodule ActivityPlanner.Accounts.UserRole do
  use Ecto.Schema
  import Ecto.Changeset

  schema "user_roles" do
    field :role, :string
    field :user_id, :id
    field :company_id, :id

    timestamps()
  end

  @doc false
  def changeset(user_role, attrs) do
    user_role
    |> cast(attrs, [:role, :user_id, :company_id])
    |> validate_required([:role, :user_id, :company_id])
  end
end
