defmodule ActivityPlanner.Participants.Participant do
  use Ecto.Schema
  import Ecto.Changeset

  schema "participants" do
    field :email, :string
    field :name, :string
    field :phone, :string
    field :description, :string

    timestamps()
  end

  @doc false
  def changeset(participant, attrs) do
    participant
    |> cast(attrs, [:name, :email, :phone, :description])
    |> validate_required([:name, :email, :phone])
  end
end
