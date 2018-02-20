defmodule Tasktracker.TaskManager do
  @moduledoc """
  The TaskManager context.
  """

  import Ecto.Query, warn: false
  alias Tasktracker.Repo

  alias Tasktracker.TaskManager.Task
  alias Tasktracker.TaskManager.Timetracker

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
    |> Repo.preload(:user)
    |> Repo.preload(:timetrackers)
  end



  @doc """

  """
  def get_task_with_single_timetracker!(id, user_id) do
    Repo.get!(Task, id)
    |> Repo.preload(:user)
    |> Repo.preload(timetrackers:  from(tt in Timetracker, where: tt.user_id == ^user_id))
  end

  @doc """

  """
  def get_task_by_user_id(user_id) do
    query = from t in Task, where: t.user_id == ^user_id
    Repo.all(query)
    |> Repo.preload(:user)
    |> Repo.preload(timetrackers:  from(tt in Timetracker, where: tt.user_id == ^user_id))
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
#    IO.inspect "Attributes are"
#    IO.inspect "Attributes are"
#    IO.inspect attrs."timetrackers"."0"

    %Task{}
    |> Task.changesetWithTimetracker(attrs)
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

  alias Tasktracker.TaskManager.Timetracker

  @doc """
  Returns the list of timetrackers.

  ## Examples

      iex> list_timetrackers()
      [%Timetracker{}, ...]

  """
  def list_timetrackers do
    Repo.all(Timetracker)
  end

  @doc """
  Gets a single timetracker.

  Raises `Ecto.NoResultsError` if the Timetracker does not exist.

  ## Examples

      iex> get_timetracker!(123)
      %Timetracker{}

      iex> get_timetracker!(456)
      ** (Ecto.NoResultsError)

  """
  def get_timetracker!(id), do: Repo.get!(Timetracker, id)

  @doc """
  Creates a timetracker.

  ## Examples

      iex> create_timetracker(%{field: value})
      {:ok, %Timetracker{}}

      iex> create_timetracker(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_timetracker(attrs \\ %{}) do
    %Timetracker{}
    |> Timetracker.changeset(attrs)
    |> Repo.insert()
  end

  def create_timetracker_with_post(%Timetracker{} = timetracker, attrs \\ %{}) do
    timetracker
    |> Timetracker.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a timetracker.

  ## Examples

      iex> update_timetracker(timetracker, %{field: new_value})
      {:ok, %Timetracker{}}

      iex> update_timetracker(timetracker, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_timetracker(%Timetracker{} = timetracker, attrs) do
    timetracker
    |> Timetracker.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Timetracker.

  ## Examples

      iex> delete_timetracker(timetracker)
      {:ok, %Timetracker{}}

      iex> delete_timetracker(timetracker)
      {:error, %Ecto.Changeset{}}

  """
  def delete_timetracker(%Timetracker{} = timetracker) do
    Repo.delete(timetracker)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking timetracker changes.

  ## Examples

      iex> change_timetracker(timetracker)
      %Ecto.Changeset{source: %Timetracker{}}

  """
  def change_timetracker(%Timetracker{} = timetracker) do
    Timetracker.changeset(timetracker, %{})
  end

  def get_timetracker_by_post_id_and_user_id(task_id, user_id) do
#    query = from t in Timetracker, where: t.user_id == ^user_id, where: t.task_id == ^task_id
#    Repo.get!(Timetracker, )
    Repo.get_by(Timetracker, user_id: user_id, task_id: task_id)
  end

end
