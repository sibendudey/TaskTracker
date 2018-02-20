defmodule Tasktracker.TaskManager.Task do
  use Ecto.Schema
  import Ecto.Changeset
  alias Tasktracker.TaskManager.Task

  schema "tasks" do
    field :completed, :boolean, default: false
    field :description, :string
    field :title, :string
    belongs_to :user, Tasktracker.Accounts.User
    has_many :timetrackers, Tasktracker.TaskManager.Timetracker
    timestamps()
  end

  @doc false
  def changeset(%Task{} = task, attrs) do
    task
    |> cast(attrs, [:title, :description, :completed, :user_id])
    |> validate_required([:title, :description, :completed, :user_id])
    |> cast_assoc(:timetrackers)
  end

  @doc false
  def changesetWithTimetracker(%Task{} = task, attrs) do
    task
    |> cast(attrs, [:title, :description, :completed, :user_id])
    |> validate_required([:title, :description, :completed, :user_id])
    |> cast_assoc(:timetrackers)
  end

  @doc false
  def updatechangeset(%Task{} = task, attrs) do
    task
    |> cast(attrs, [:title, :description, :completed, :user_id])
    |> validate_required([:title, :description, :completed, :user_id])
    |> cast_assoc(:timetrackers, required: true)
  end



end
