defmodule Tasktracker.TaskManager.Task do
  use Ecto.Schema
  import Ecto.Changeset
  alias Tasktracker.TaskManager.Task


  schema "tasks" do
    field :completed, :boolean, default: false
    field :description, :string
    field :title, :string
    field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset(%Task{} = task, attrs) do
    task
    |> cast(attrs, [:title, :description, :completed])
    |> validate_required([:title, :description, :completed])
  end
end
