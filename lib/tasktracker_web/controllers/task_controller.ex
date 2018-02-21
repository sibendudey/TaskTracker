defmodule TasktrackerWeb.TaskController do
  use TasktrackerWeb, :controller

  alias Tasktracker.TaskManager
  alias Tasktracker.TaskManager.Task
  alias Tasktracker.TaskManager.Timetracker
  alias Tasktracker.Repo

#  def index(conn, _params) do
#    tasks = TaskManager.list_tasks()
#    render(conn, "index.html", tasks: tasks)
#  end

  def new(conn, _params) do
    task = %Task{timetrackers: [%Timetracker{}]}
    changeset = TaskManager.change_task(task)
    users = Tasktracker.Accounts.list_users()
            |> Enum.map(&{&1.name, &1.id})
    render(conn, "new.html", changeset: changeset, users: users)
  end

  def create(conn, %{"task" => task_params}) do

    tasktracker_params = Map.get(task_params, "timetrackers")
                         |> Map.get("0")
                         |> Map.put("user_id", String.to_integer(Map.get(task_params, "user_id")))

    tasktracker_params = for {key, val} <- tasktracker_params, into: %{}, do: {String.to_atom(key), val}

    if tasktracker_params.user_id != get_session(conn, :user_id) do
      tasktracker_params = tasktracker_params |> Map.delete(:time)
    end

    changeset = Timetracker.changeset(%Timetracker{}, tasktracker_params)

    case changeset.valid? do
      true -> case TaskManager.create_task(
                     task_params
                     |> Map.delete("timetrackers")
                   ) do
                {:ok, task} ->
                  task_with_timetracker = Ecto.build_assoc(task, :timetrackers)
                  case TaskManager.create_timetracker_with_post(task_with_timetracker, tasktracker_params) do
                    {:ok, timetracker} ->
                      conn
                      |> put_flash(:info, "Task created successfully.")
                      |> redirect(to: page_path(conn, :feed, user_id: get_session(conn, :user_id)))
                    {:error, %Ecto.Changeset{} = changeset} ->
                      users = Tasktracker.Accounts.list_users()
                              |> Enum.map(&{&1.name, &1.id})
                      render(conn, "new.html", changeset: changeset, users: users)
                  end
                {:error, %Ecto.Changeset{} = changeset} ->
                  users = Tasktracker.Accounts.list_users()
                          |> Enum.map(&{&1.name, &1.id})
                  render(conn, "new.html", changeset: changeset, users: users)
              end

      false ->
        changeset = Task.changesetWithTimetracker(%Task{}, task_params)
        users = Tasktracker.Accounts.list_users()
                |> Enum.map(&{&1.name, &1.id})
        render(conn, "new.html", changeset: changeset, users: users)
    end
  end

  def show(conn, %{"id" => id}) do
    task = TaskManager.get_task_with_single_timetracker!(id, get_session(conn, :user_id))
    render(conn, "show.html", task: task)
  end

  def edit(conn, %{"id" => id}) do
    task = TaskManager.get_task_with_single_timetracker!(id, get_session(conn, :user_id))
    changeset = TaskManager.change_task(task)
    users = Tasktracker.Accounts.list_users()
            |> Enum.map(&{&1.name, &1.id})
    render(conn, "edit.html", task: task, changeset: changeset, users: users)
  end

  def update(conn, %{"id" => id, "task" => task_params}) do

    tasktracker_params = Map.get(task_params, "timetrackers")
                         |> Map.get("0")
                         |> Map.put("user_id", String.to_integer(Map.get(task_params, "user_id")))

    tasktracker_params = for {key, val} <- tasktracker_params, into: %{}, do: {String.to_atom(key), val}

    tasktracker_params = tasktracker_params
                         |> Map.delete(:id)

    if tasktracker_params.user_id != get_session(conn, :user_id) do
      tasktracker_params = tasktracker_params
                           |> Map.delete(:time)
    end

    changeset = Timetracker.changeset(%Timetracker{}, tasktracker_params)
    task = TaskManager.get_task_with_single_timetracker!(id, get_session(conn, :user_id))

    case changeset.valid? do
      true ->
        case TaskManager.update_task(task, task_params |> Map.delete("timetrackers")) do
          {:ok, task} ->
            timetracker = TaskManager.get_timetracker_by_post_id_and_user_id(id, Map.get(tasktracker_params, :user_id))
            if timetracker == nil do
              task_with_timetracker = Ecto.build_assoc(task, :timetrackers)
              TaskManager.create_timetracker_with_post(task_with_timetracker, tasktracker_params)
            else
              TaskManager.update_timetracker(timetracker, tasktracker_params)
            end
            conn
            |> put_flash(:info, "Task updated successfully.")
            |> redirect(to: page_path(conn, :feed, user_id: get_session(conn, :user_id)))
          {:error, %Ecto.Changeset{} = changeset} ->
            users = Tasktracker.Accounts.list_users()
                    |> Enum.map(&{&1.name, &1.id})
            render(conn, "edit.html", task: task, changeset: changeset, users: users)
        end
      false ->
        changeset = Task.changesetWithTimetracker(task, task_params)
        users = Tasktracker.Accounts.list_users() |> Enum.map(&{&1.name, &1.id})
        render(conn, "edit.html", task: task, changeset: changeset, users: users)
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
