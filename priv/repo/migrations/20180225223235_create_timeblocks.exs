defmodule Tasktracker.Repo.Migrations.CreateTimeblocks do
  use Ecto.Migration

  def change do
    create table(:timeblocks) do
      add :starttime, :utc_datetime
      add :endtime, :utc_datetime
      add :user_id, references(:users, on_delete: :all), null: false
      add :task_id, references(:tasks, on_delete: :all), null: false

      timestamps()
    end

    create index(:timeblocks, [:user_id])
    create index(:timeblocks, [:task_id])
  end
end
