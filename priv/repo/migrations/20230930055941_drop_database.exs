defmodule ActivityPlanner.Repo.Migrations.DropDatabase do
  use Ecto.Migration

  def change do
    drop table("companies"), mode: :cascade
    drop table("activities"), mode: :cascade
    drop table("activity_groups"), mode: :cascade
    drop table("activity_participants"), mode: :cascade
    drop table("notification_schedules"), mode: :cascade
    drop table("notification_templates"), mode: :cascade
    drop table("sent_notifications"), mode: :cascade
    drop table("participants"), mode: :cascade
    drop table("users"), mode: :cascade
    drop table("user_roles"), mode: :cascade
    drop table("users_tokens"), mode: :cascade
    execute "DROP TYPE notification_medium_enum", ""
    execute "DROP TYPE notification_status_enum", ""
  end
end
