defmodule ActivityPlanner.Repo.Migrations.CreateUserRoles do
  use Ecto.Migration

  def change do
    create table(:user_roles) do
      add :role, :string
      add :user_id, references(:users, on_delete: :nothing)
      add :company_id, references(:companies, on_delete: :nothing)

      timestamps()
    end

    create index(:user_roles, [:user_id])
    create index(:user_roles, [:company_id])
  end
end
