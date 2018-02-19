defmodule Tasktracker.Repo.Migrations.CreateTimetrackers do
  use Ecto.Migration

  def change do
    create table(:timetrackers) do
      add :time, :integer
      add :user_id, references(:users, on_delete: :delete_all)
      add :task_id, references(:tasks, on_delete: :delete_all)

      timestamps()
    end

    create index(:timetrackers, [:user_id])
    create index(:timetrackers, [:task_id])
  end
end
