defmodule TasktrackerWeb.PageController do
  use TasktrackerWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def feed(conn, params) do
    tasks = Tasktracker.TaskManager.get_task_by_user_id(params["user"])
    changeset = Tasktracker.TaskManager.change_task(%Tasktracker.TaskManager.Task{})
    users = Tasktracker.Accounts.list_users() |> Enum.map(&{&1.name, &1.id})
    render conn, "feed.html", tasks: tasks, changeset: changeset, users: users
  end
end
