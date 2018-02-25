defmodule TasktrackerWeb.PageController do
  use TasktrackerWeb, :controller
  alias Tasktracker.TaskManager.Timetracker
  alias Tasktracker.TaskManager.Task
  alias Tasktracker.Accounts.User

  def index(conn, _params) do
    render conn, "index.html"
  end

  def feed(conn, params) do
    tasks = Tasktracker.TaskManager.get_tasks_by_user_id(params["user_id"])
    task = %Task{timetrackers: [%Timetracker{}]}
    changeset = Tasktracker.TaskManager.change_task(task)
    users = Tasktracker.Accounts.list_users() |> Enum.map(&{&1.name, &1.id})
    render conn, "feed.html", tasks: tasks, changeset: changeset, users: users
  end

  def profile(conn, params) do
    current_user = conn.assigns[:current_user]
    users = Tasktracker.Accounts.list_users_for_manage(current_user.id)
    manages = Tasktracker.Accounts.managee_map_for(current_user.id)
    case Tasktracker.Accounts.get_manager(current_user.id) do
      {:ok, %User{} = manager} -> render conn, "profile.html", users: users, manages: manages, manager: manager
      {:manager_not_found, ""} -> render conn, "profile.html", users: users, manages: manages, manager: ""
    end

  end
end
