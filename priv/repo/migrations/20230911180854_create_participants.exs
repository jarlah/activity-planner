defmodule ActivityPlanner.Repo.Migrations.CreateParticipants do
  use Ecto.Migration

  def change do
    create table(:participants) do
      add :name, :string
      add :email, :string
      add :phone, :string

      timestamps()
    end
  end
end
