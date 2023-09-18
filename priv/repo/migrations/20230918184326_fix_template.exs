defmodule ActivityPlanner.Repo.Migrations.FixTemplate do
  use Ecto.Migration

  def change do
    execute "delete from notification_schedules"
    execute "delete from notification_templates"

    alter table(:notification_templates) do
      remove(:activity_group_id)
      add :company_id, references(:companies, on_delete: :nothing), null: false
    end
  end
end
