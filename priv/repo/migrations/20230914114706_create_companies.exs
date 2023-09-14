defmodule ActivityPlanner.Repo.Migrations.CreateCompanies do
  use Ecto.Migration

  def change do
    create table(:companies) do
      add :name, :string
      add :address, :string
      add :description, :text

      timestamps()
    end
  end
end
