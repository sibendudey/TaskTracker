defmodule Tasktracker.TaskManager.Timetracker do
  use Ecto.Schema
  import Ecto.Changeset
  alias Tasktracker.TaskManager.Timetracker


  schema "timetrackers" do
    field :time, :integer, default: 0
    belongs_to :user, Tasktracker.Accounts.User
    belongs_to :task, Tasktracker.TaskManager.Task

    timestamps()
  end

  @doc false
  def changeset(%Timetracker{} = timetracker, attrs) do
    timetracker
    |> cast(attrs, [:time, :user_id, :task_id])
#    |> validate_required([:time, :user_id])
    |> validate_change(
         :time,
         fn :time, time ->
           if rem(time, 15) != 0 do
             [time: "time should be an increment of 15"]
           else
             []
           end
         end
       )
  end
end
