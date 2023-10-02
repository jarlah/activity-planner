defmodule ActivityPlanner.Repo.Migrations.CreateNotificationSettings do
  use Ecto.Migration

  def change do
    execute "CREATE TYPE notification_status_enum AS ENUM ('sent', 'failed');"
    execute "CREATE TYPE notification_medium_enum AS ENUM ('sms', 'email');"

    create table(:notification_templates) do
      add :template_content, :text, null: false
      add :title, :string, null: false

      timestamps()
    end

    create table(:notification_settings) do
      add :day_in_advance_template_id, references(:notification_templates, on_delete: :nothing)

      timestamps()
    end

    alter table(:activity_groups) do
      add :notification_setting_id, references(:notification_settings, on_delete: :nothing)
    end

    create table(:sent_notifications) do
      add :activity_id, references(:activities, on_delete: :delete_all)
      add :sent_at, :utc_datetime
      add :status, :notification_status_enum
      add :medium, :notification_medium_enum
      add :actual_content, :text
      add :actual_title, :string

      timestamps()
    end
  end
end
