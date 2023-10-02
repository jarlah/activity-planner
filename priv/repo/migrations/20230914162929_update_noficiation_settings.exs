defmodule ActivityPlanner.Repo.Migrations.UpdateNoficiationSettings do
  use Ecto.Migration

  def change do
    alter table(:activity_groups) do
      remove :notification_setting_id
    end

    alter table(:notification_settings) do
      add :activity_group_id, references(:activity_groups, on_delete: :nothing)
    end
  end
end
