defmodule ActivityPlanner.Repo.Migrations.AddCompanyId do
  use Ecto.Migration

  def change do
    execute "TRUNCATE activities CASCADE"

    alter table(:activities) do
      add :company_id, references(:companies, column: :company_id), null: false
    end

    alter table(:activity_participants) do
      add :company_id, references(:companies, column: :company_id), null: false
    end

    execute "TRUNCATE notification_schedules CASCADE"

    alter table(:notification_schedules) do
      add :company_id, references(:companies, column: :company_id), null: false
    end

    alter table(:sent_notifications) do
      add :company_id, references(:companies, column: :company_id), null: false
    end

    execute "TRUNCATE participants CASCADE"

    alter table(:participants) do
      add :company_id, references(:companies, column: :company_id), null: false
    end

    execute "TRUNCATE users CASCADE"

    alter table(:users) do
      add :company_id, references(:companies, column: :company_id), null: false
    end
  end
end
