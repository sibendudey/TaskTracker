defmodule Tasktracker.TaskManager.Timeblock do
  use Ecto.Schema
  import Ecto.Changeset
  alias Tasktracker.TaskManager.Timeblock


  schema "timeblocks" do
    field :endtime, :utc_datetime
    field :starttime, :utc_datetime
    belongs_to :user, Tasktracker.Accounts.User
    belongs_to :task, Tasktracker.TaskManager.Task

    timestamps()
  end

  @doc false
  def changeset(%Timeblock{} = timeblock, attrs) do
    timeblock
    |> cast(attrs, [:starttime, :endtime, :user_id, :task_id])
    |> validate_required([:starttime, :endtime, :user_id, :task_id])
  end
end
