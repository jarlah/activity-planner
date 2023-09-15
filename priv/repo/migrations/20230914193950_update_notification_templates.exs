defmodule ActivityPlanner.Repo.Migrations.UpdateNotificationTemplates do
  use Ecto.Migration

  def change do

    alter table(:notification_templates) do
      add :activity_group_id, references(:activity_groups, on_delete: :nothing )
    end
  end
end
