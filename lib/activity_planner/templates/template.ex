defmodule ActivityPlanner.Templates.Template do
  use Ecto.Schema
  import Ecto.Changeset

  schema "templates" do
    field :content, :string
    field :name, :string
    field :activity_id, :id

    timestamps()
  end

  @doc false
  def changeset(template, attrs) do
    template
    |> cast(attrs, [:name, :content])
    |> validate_required([:name, :content])
  end
end
