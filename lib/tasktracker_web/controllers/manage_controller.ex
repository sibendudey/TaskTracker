defmodule TasktrackerWeb.ManageController do
  use TasktrackerWeb, :controller

  alias Tasktracker.Accounts
  alias Tasktracker.Accounts.Manage

  action_fallback TasktrackerWeb.FallbackController

  def index(conn, _params) do
    manages = Accounts.list_manages()
    render(conn, "index.json", manages: manages)
  end

  def create(conn, %{"manage" => manage_params}) do
    with {:ok, %Manage{} = manage} <- Accounts.create_manage(manage_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", manage_path(conn, :show, manage))
      |> render("show.json", manage: manage)
    end
  end

  def show(conn, %{"id" => id}) do
    manage = Accounts.get_manage!(id)
    render(conn, "show.json", manage: manage)
  end

  def update(conn, %{"id" => id, "manage" => manage_params}) do
    manage = Accounts.get_manage!(id)

    with {:ok, %Manage{} = manage} <- Accounts.update_manage(manage, manage_params) do
      render(conn, "show.json", manage: manage)
    end
  end

  def delete(conn, %{"id" => id}) do
    manage = Accounts.get_manage!(id)
    with {:ok, %Manage{}} <- Accounts.delete_manage(manage) do
      send_resp(conn, :no_content, "")
    end
  end
end
