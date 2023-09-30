defmodule ActivityPlanner.Participants.Participant do
  use ActivityPlanner.Schema
  alias ActivityPlanner.Companies

  schema "participants" do
    field :email, :string
    field :name, :string
    field :phone, :string
    field :description, :string
    field :company_id, :binary_id

    timestamps()
  end

  @doc false
  def changeset(participant, attrs) do
    participant
    |> cast(attrs, [:name, :email, :phone, :description, :company_id])
    |> Companies.common_changeset(attrs)
    |> validate_required([:name, :email, :phone, :company_id])
    |> unique_constraint(:phone)
    |> unique_constraint(:email)
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "must have the @ sign and no spaces")
    |> validate_length(:email, max: 160)
  end
end
