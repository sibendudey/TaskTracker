defmodule TasktrackerWeb.TaskController do
  use TasktrackerWeb, :controller

  alias Tasktracker.TaskManager
  alias Tasktracker.TaskManager.Task
  alias Tasktracker.TaskManager.Timetracker
  alias Tasktracker.Repo

  def new(conn, _params) do
    task = %Task{timetrackers: [%Timetracker{}]}
    changeset = TaskManager.change_task(task)
    current_user = conn.assigns[:current_user]
    users = Tasktracker.Accounts.list_users_for_task_assignment(current_user.id)
            |> Enum.map(&{&1.name, &1.id})
    render(conn, "new.html", changeset: changeset, users: users)
  end

  def create(conn, %{"task" => task_params}) do
    current_user = conn.assigns[:current_user]
    case TaskManager.create_task(task_params) do
      {:ok, task} ->
        conn
        |> put_flash(:info, "Task created successfully.")

        ## If the manager creates a task for himself,
        ## Go to this task feed, else go to the managee feed
        if task.user_id == current_user.id do
          conn
          |> redirect(to: page_path(conn, :feed, user_id: get_session(conn, :user_id)))
        else
          conn
          |> redirect(to: page_path(conn, :managee_feed, user_id: get_session(conn, :user_id)))
        end

      {:error, %Ecto.Changeset{} = changeset} ->
        users = users = Tasktracker.Accounts.list_users_for_task_assignment(current_user.id)
                        |> Enum.map(&{&1.name, &1.id})
        render(conn, "new.html", changeset: changeset, users: users)
    end
  end

  def show(conn, %{"id" => id}) do
    current_user = conn.assigns[:current_user]
    case current_user.manager do
      true ->
        task = TaskManager.get_task_with_time_blocks_managee!(id, current_user.id)
        render(conn, "show.html", task: task)
      false ->
        task = TaskManager.get_task_with_time_blocks!(id, current_user.id)
        render(conn, "show.html", task: task)
    end
  end


  def edit(conn, %{"id" => id}) do
    current_user = conn.assigns[:current_user]
    task = TaskManager.get_task_with_time_blocks!(id, get_session(conn, :user_id))
    changeset = TaskManager.change_task(task)
    users = Tasktracker.Accounts.list_users_for_task_assignment(current_user.id)
            |> Enum.map(&{&1.name, &1.id})
    render(conn, "edit.html", task: task, changeset: changeset, users: users)
  end

  def update(conn, %{"id" => id, "task" => task_params}) do
    current_user = conn.assigns[:current_user]
    task = TaskManager.get_task_with_time_blocks!(id, get_session(conn, :user_id))
    case TaskManager.update_task(task, task_params) do
      {:ok, task} ->
        conn = conn
        |> put_flash(:info, "Task updated successfully.")

        # similar redirection compared to new
        if task.user_id == current_user.id do
          conn
          |> redirect(to: page_path(conn, :feed, user_id: get_session(conn, :user_id)))
        else
          conn
          |> redirect(to: page_path(conn, :managee_feed, user_id: get_session(conn, :user_id)))
        end
      {:error, %Ecto.Changeset{} = changeset} ->
        users = Tasktracker.Accounts.list_users_for_task_assignment(current_user.id)
                |> Enum.map(&{&1.name, &1.id})
        render(conn, "edit.html", task: task, users: users, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    current_user = conn.assigns[:current_user]
    task = TaskManager.get_task!(id)
    {:ok, _task} = TaskManager.delete_task(task)
    conn
    |> put_flash(:info, "Task deleted successfully.")

    if task.user_id == current_user.id do
      conn
      |> redirect(to: page_path(conn, :feed, user_id: get_session(conn, :user_id)))
    else
      conn
      |> redirect(to: page_path(conn, :managee_feed, user_id: get_session(conn, :user_id)))
    end
  end
end
