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
    |> validate_dates_make_sense
  end

  ## Code copied from stack overflow and modified with resource fields.
  ## https://stackoverflow.com/questions/46281493/validate-than-one-date-is-later-or-same-than-the-other
  defp validate_dates_make_sense(changeset) do
    starttime = get_field(changeset, :starttime)
    endtime = get_field(changeset, :endtime)

    if Date.compare(starttime, endtime) == :gt do
      add_error(changeset, :starttime, "start time cannot be later than 'end time'")
    else
      changeset
    end
  end
end
