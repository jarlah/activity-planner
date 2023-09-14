defmodule ActivityPlanner.Repo.Migrations.CreateTemplates do
  use Ecto.Migration

  def change do
    create table(:templates) do
      add :name, :string
      add :content, :text
      add :activity_id, references(:activities, on_delete: :nothing)

      timestamps()
    end

    create index(:templates, [:activity_id])
  end
end
