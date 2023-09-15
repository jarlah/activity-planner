defmodule ActivityPlanner.Repo.Migrations.UpdateSentNotifications do
  use Ecto.Migration

  def change do
    alter table(:sent_notifications) do
      add :receiver, :string
    end
  end
end
