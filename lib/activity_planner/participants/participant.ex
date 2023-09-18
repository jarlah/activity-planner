defmodule ActivityPlanner.Participants.Participant do
  use Ecto.Schema
  import Ecto.Changeset

  schema "participants" do
    field :email, :string
    field :name, :string
    field :phone, :string
    field :description, :string

    belongs_to :user, ActivityPlanner.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(participant, attrs) do
    participant
    |> cast(attrs, [:name, :email, :phone, :description, :user_id])
    |> validate_required([:name, :email, :phone])
    |> unique_constraint(:phone)
    |> unique_constraint(:email)
  end
end
