defmodule Tasktracker.TaskManager do
  @moduledoc """
  The TaskManager context.
  """

  import Ecto.Query, warn: false
  alias Tasktracker.Repo

  alias Tasktracker.TaskManager.Task
  alias Tasktracker.Accounts.Manage
  alias Tasktracker.TaskManager.Timeblock

  @doc """
  Returns the list of tasks.

  ## Examples

      iex> list_tasks()
      [%Task{}, ...]

  """
  def list_tasks do
    Repo.all(Task)
  end

  @doc """
  Gets a single task.

  Raises `Ecto.NoResultsError` if the Task does not exist.

  ## Examples

      iex> get_task!(123)
      %Task{}

      iex> get_task!(456)
      ** (Ecto.NoResultsError)

  """
  def get_task!(id) do
    Repo.get!(Task, id)
  end



  @doc """

  Returns a tasks with time blocks assigned
  for the user having id as user_id
  """
  def get_task_with_time_blocks!(id, user_id) do
    Repo.get!(Task, id)
    |> Repo.preload(:user)
    |> Repo.preload(timeblocks:  from(tt in Timeblock, where: tt.user_id == ^user_id))
  end

  @doc """

  Returns a tasks with time blocks for managee task feed
  """
  def get_task_with_time_blocks_managee!(id, manager_id) do
    query = from t in Task,
              left_join: tb in Timeblock, on: tb.task_id == t.id,on: tb.user_id == t.user_id,
              where: is_nil(tb.user_id) or t.user_id == tb.user_id,
              where: t.id == ^id,
              preload: [timeblocks: tb],
              preload: :user

    result = Repo.one(query)
    IO.inspect result
    result
  end


  def get_tasks_by_user_id(user_id) do
    query = from t in Task,
                 where: t.user_id == ^user_id

    Repo.all(query) |> Repo.preload(timeblocks: from(tt in Timeblock, where: tt.user_id == ^user_id))
  end

  @doc """

  """
  def get_managee_tasks(manager_user_id) do
    query = from t in Task,
                 left_join: tb in Timeblock, on: tb.task_id == t.id,on: tb.user_id == t.user_id,
                 join: m in Manage, on: m.managee_id == t.user_id,
                 where: m.manager_id == ^manager_user_id,
                 preload: [timeblocks: tb],
                 preload: :user

    Repo.all(query)
  end


  @doc """
  Creates a task.

  ## Examples

      iex> create_task(%{field: value})
      {:ok, %Task{}}

      iex> create_task(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_task(attrs \\ %{}) do
    %Task{}
    |> Task.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a task.

  ## Examples

      iex> update_task(task, %{field: new_value})
      {:ok, %Task{}}

      iex> update_task(task, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_task(%Task{} = task, attrs) do
    task
    |> Task.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Task.

  ## Examples

      iex> delete_task(task)
      {:ok, %Task{}}

      iex> delete_task(task)
      {:error, %Ecto.Changeset{}}

  """
  def delete_task(%Task{} = task) do
    Repo.delete(task)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking task changes.

  ## Examples

      iex> change_task(task)
      %Ecto.Changeset{source: %Task{}}

  """
  def change_task(%Task{} = task) do
    Task.changeset(task, %{})
  end

  alias Tasktracker.TaskManager.Timeblock

  @doc """
  Returns the list of timeblocks.

  ## Examples

      iex> list_timeblocks()
      [%Timeblock{}, ...]

  """
  def list_timeblocks do
    Repo.all(Timeblock)
  end

  @doc """
  Gets a single timeblock.

  Raises `Ecto.NoResultsError` if the Timeblock does not exist.

  ## Examples

      iex> get_timeblock!(123)
      %Timeblock{}

      iex> get_timeblock!(456)
      ** (Ecto.NoResultsError)

  """
  def get_timeblock!(id), do: Repo.get!(Timeblock, id)

  @doc """
  Creates a timeblock.

  ## Examples

      iex> create_timeblock(%{field: value})
      {:ok, %Timeblock{}}

      iex> create_timeblock(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_timeblock(attrs \\ %{}) do
    %Timeblock{}
    |> Timeblock.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a timeblock.

  ## Examples

      iex> update_timeblock(timeblock, %{field: new_value})
      {:ok, %Timeblock{}}

      iex> update_timeblock(timeblock, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_timeblock(%Timeblock{} = timeblock, attrs) do
    timeblock
    |> Timeblock.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Timeblock.

  ## Examples

      iex> delete_timeblock(timeblock)
      {:ok, %Timeblock{}}

      iex> delete_timeblock(timeblock)
      {:error, %Ecto.Changeset{}}

  """
  def delete_timeblock(%Timeblock{} = timeblock) do
    Repo.delete(timeblock)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking timeblock changes.

  ## Examples

      iex> change_timeblock(timeblock)
      %Ecto.Changeset{source: %Timeblock{}}

  """
  def change_timeblock(%Timeblock{} = timeblock) do
    Timeblock.changeset(timeblock, %{})
  end
end
