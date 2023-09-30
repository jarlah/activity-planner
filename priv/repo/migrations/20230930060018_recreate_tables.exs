defmodule ActivityPlanner.Repo.Migrations.RecreateTables do
  use Ecto.Migration

  def change do
    execute "CREATE EXTENSION IF NOT EXISTS citext", ""
    execute "CREATE EXTENSION IF NOT EXISTS pgcrypto", ""

    create table(:companies, primary_key: false) do
      add :company_id, :uuid, primary_key: true, null: false, default: fragment("gen_random_uuid()")
      add :name, :string
      add :address, :string
      add :description, :text
      timestamps()
    end

    create table(:users, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false, default: fragment("gen_random_uuid()")
      add :email, :citext, null: false
      add :hashed_password, :string, null: false
      add :confirmed_at, :naive_datetime
      add :company_id, :uuid, null: false
      timestamps()
    end

    create unique_index(:users, [:email])

    create table(:users_tokens, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false, default: fragment("gen_random_uuid()")
      add :user_id, references(:users, type: :uuid, on_delete: :nothing), null: false
      add :token, :binary, null: false
      add :context, :string, null: false
      add :sent_to, :string
      add :company_id, :uuid, null: false
      timestamps(updated_at: false)
    end

    create index(:users_tokens, [:user_id])
    create unique_index(:users_tokens, [:context, :token])

    create table(:user_roles, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false, default: fragment("gen_random_uuid()")
      add :role, :string
      add :user_id, references(:users, type: :uuid, on_delete: :nothing), null: false
      add :company_id, :uuid, null: false
      timestamps()
    end

    create index(:user_roles, [:user_id])
    create index(:user_roles, [:company_id])

    create table(:activity_groups, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false, default: fragment("gen_random_uuid()")
      add :name, :string
      add :description, :text
      add :company_id, :uuid, null: false
      timestamps()
    end

    create index(:activity_groups, [:company_id])

    create table(:activities, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false, default: fragment("gen_random_uuid()")
      add :title, :string
      add :description, :text
      add :start_time, :utc_datetime
      add :end_time, :utc_datetime
      add :responsible_participant_id, :integer
      add :activity_group_id, references(:activity_groups, type: :uuid, on_delete: :nothing), null: false
      add :company_id, :uuid, null: false
      timestamps()
    end

    create index(:activities, [:activity_group_id])
    create index(:activities, [:company_id])

    create table(:participants, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false, default: fragment("gen_random_uuid()")
      add :name, :string
      add :email, :string
      add :phone, :string
      add :description, :text
      add :company_id, :uuid, null: false
      timestamps()
    end

    create index(:participants, [:company_id])
    create unique_index(:participants, [:phone])
    create unique_index(:participants, [:email])

    create table(:activity_participants, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false, default: fragment("gen_random_uuid()")
      add :activity_id, references(:activities, type: :uuid, on_delete: :nothing), null: false
      add :participant_id, references(:participants, type: :uuid, on_delete: :nothing), null: false
      add :company_id, :uuid, null: false
      timestamps()
    end

    create unique_index(:activity_participants, [:activity_id, :participant_id])

    create index(:activity_participants, [:activity_id])
    create index(:activity_participants, [:participant_id])
    create index(:activity_participants, [:company_id])

    create table(:notification_templates, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false, default: fragment("gen_random_uuid()")
      add :template_content, :text, null: false
      add :title, :string, null: false
      add :company_id, :uuid, null: false
      timestamps()
    end

    execute "CREATE TYPE notification_status_enum AS ENUM ('sent', 'failed');", "DROP TYPE notification_status_enum"
    execute "CREATE TYPE notification_medium_enum AS ENUM ('sms', 'email');", "DROP TYPE notification_medium_enum"

    create table(:notification_schedules, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false, default: fragment("gen_random_uuid()")
      add :name, :string
      add :medium, :notification_medium_enum
      add :cron_expression, :map
      add :hours_window_offset, :integer, default: 0
      add :hours_window_length, :integer
      add :enabled, :boolean, default: true
      add :activity_group_id, references(:activity_groups, type: :uuid, on_delete: :nothing), null: false
      add :template_id, references(:notification_templates, type: :uuid, on_delete: :nothing), null: false
      add :company_id, :uuid, null: false
      timestamps()
    end

    create table(:sent_notifications, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false, default: fragment("gen_random_uuid()")
      add :activity_id, references(:activities, type: :uuid, on_delete: :nothing), null: false
      add :sent_at, :utc_datetime, null: false
      add :status, :notification_status_enum, null: false
      add :medium, :notification_medium_enum, null: false
      add :actual_content, :text, null: false
      add :actual_title, :string
      add :receiver, :string, null: false
      add :company_id, :uuid, null: false
      timestamps()
    end
  end
end
