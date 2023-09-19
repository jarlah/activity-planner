defmodule ActivityPlanner.Repo.Migrations.RenameIdToCompanyIdInCompany do
  use Ecto.Migration

  def change do
    rename table(:companies), :id, to: :company_id
  end
end
