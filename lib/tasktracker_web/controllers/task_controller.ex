defmodule TasktrackerWeb.TaskController do
  use TasktrackerWeb, :controller

  alias Tasktracker.TaskManager
  alias Tasktracker.TaskManager.Task
  alias Tasktracker.TaskManager.Timetracker
  alias Tasktracker.Repo

  def index(conn, _params) do
    tasks = TaskManager.list_tasks()
    render(conn, "index.html", tasks: tasks)
  end

  def new(conn, _params) do
    IO.puts "new is called"
    task = %Task{timetrackers: [%Timetracker{}, %Timetracker{}]}
#    changeset = TaskManager.change_task(%Task{})
    changeset = TaskManager.change_task(task)
#    changeset = Task.changeset(task)
    users = Tasktracker.Accounts.list_users() |> Enum.map(&{&1.name, &1.id})
    render(conn, "new.html", changeset: changeset, users: users)
  end

#  def create(conn, %{"task" => task_params}) do
#    case TaskManager.create_task(task_params) do
#      {:ok, task} ->
#        conn
#        |> put_flash(:info, "Task created successfully.")
#        |> redirect(to: task_path(conn, :show, task))
#      {:error, %Ecto.Changeset{} = changeset} ->
#        users = Tasktracker.Accounts.list_users() |> Enum.map(&{&1.name, &1.id})
#        render(conn, "new.html", changeset: changeset, users: users)
#    end
#  end

  def create(conn, %{"task" => task_params}) do
    tasktracker_params = Map.get(task_params, "timetrackers")
                         |> Map.get("0")
                         |> Map.put(:user_id, String.to_integer(Map.get(task_params, "user_id")))
                          |> Map.delete("user_id")

    tasktracker_params = Map.put(tasktracker_params, :time,
                           String.to_integer(Map.get(tasktracker_params, "time")))
    |> Map.delete("time")

    IO.inspect tasktracker_params
#    tasktracker_params =
#      for {key, val} <- tasktracker_params, into: %{}, do: {String.to_atom(key), val}

    case TaskManager.create_task(task_params) do
      {:ok, task} ->
#        timetracker =  Ecto.Changeset.change(%Timetracker{}, tasktracker_params)
        task_with_timetracker = Ecto.build_assoc(task, :timetrackers, tasktracker_params)
        IO.inspect task_with_timetracker
        Repo.insert!(task_with_timetracker)
        conn
        |> put_flash(:info, "Task created successfully.")
        |> redirect(to: page_path(conn, :feed, user_id: get_session(conn, :user_id)))
      {:error, %Ecto.Changeset{} = changeset} ->
        users = Tasktracker.Accounts.list_users() |> Enum.map(&{&1.name, &1.id})
        render(conn, "new.html", changeset: changeset, users: users)
    end
  end


  def show(conn, %{"id" => id}) do
    task = TaskManager.get_task!(id)
    render(conn, "show.html", task: task)
  end

  def edit(conn, %{"id" => id}) do
    task = TaskManager.get_task!(id)
    changeset = TaskManager.change_task(task)
    users = Tasktracker.Accounts.list_users() |> Enum.map(&{&1.name, &1.id})
    render(conn, "edit.html", task: task, changeset: changeset, users: users)
  end

  def update(conn, %{"id" => id, "task" => task_params}) do

    IO.inspect task_params
    tasktracker_params = Map.get(task_params, "timetrackers")
                         |> Map.get("0")
                         |> Map.put(:user_id, String.to_integer(Map.get(task_params, "user_id")))
                         |> Map.delete("user_id")

    tasktracker_params = Map.put(tasktracker_params, :time,
                           String.to_integer(Map.get(tasktracker_params, "time")))
                         |> Map.delete("time")


    task = TaskManager.get_task!(id)
    case TaskManager.update_task(task, task_params) do
      {:ok, task} ->
        timetracker = TaskManager.get_timetracker_by_post_id_and_user_id(id, Map.get(tasktracker_params, :user_id))
        if timetracker == [] do
          task_with_timetracker = Ecto.build_assoc(task, :timetrackers, tasktracker_params)
          IO.inspect task_with_timetracker
          Repo.insert!(task_with_timetracker)
        else
          TaskManager.update_timetracker(timetracker, tasktracker_params)
        end
        conn
        |> put_flash(:info, "Task updated successfully.")
        |> redirect(to: page_path(conn, :feed, user_id: get_session(conn, :user_id)))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", task: task, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    task = TaskManager.get_task!(id)
    {:ok, _task} = TaskManager.delete_task(task)

    conn
    |> put_flash(:info, "Task deleted successfully.")
    |> redirect(to: page_path(conn, :feed, user_id: get_session(conn, :user_id)))
  end
end
