defmodule ActivityPlanner.Schemas.Participant do
  use Ecto.Schema
  import Ecto.Changeset

  schema "participants" do
    field :email, :string
    field :name, :string
    field :phone, :string

    many_to_many :activities, ActivityPlanner.Schemas.Activity, join_through: "activity_participants"

    timestamps()
  end

  @doc false
  def changeset(participant, attrs) do
    participant
    |> cast(attrs, [:name, :email, :phone])
    |> validate_required([:name, :email, :phone])
  end
end
