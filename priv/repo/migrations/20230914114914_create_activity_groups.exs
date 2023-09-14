defmodule ActivityPlanner.Repo.Migrations.CreateActivityGroups do
  use Ecto.Migration

  def change do
    create table(:activity_groups) do
      add :name, :string
      add :description, :text
      add :company_id, references(:companies, on_delete: :nothing)

      timestamps()
    end

    create index(:activity_groups, [:company_id])
  end
end
