defmodule TasktrackerWeb.TimeblockController do
  use TasktrackerWeb, :controller

  alias Tasktracker.TaskManager
  alias Tasktracker.TaskManager.Timeblock

  action_fallback TasktrackerWeb.FallbackController

  def index(conn, _params) do
    timeblocks = TaskManager.list_timeblocks()
    render(conn, "index.json", timeblocks: timeblocks)
  end

  def create(conn, %{"timeblock" => timeblock_params}) do
    with {:ok, %Timeblock{} = timeblock} <- TaskManager.create_timeblock(timeblock_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", timeblock_path(conn, :show, timeblock))
      |> render("show.json", timeblock: timeblock)
    end
  end

  def show(conn, %{"id" => id}) do
    timeblock = TaskManager.get_timeblock!(id)
    render(conn, "show.json", timeblock: timeblock)
  end

  def update(conn, %{"id" => id, "timeblock" => timeblock_params}) do
    timeblock = TaskManager.get_timeblock!(id)

    with {:ok, %Timeblock{} = timeblock} <- TaskManager.update_timeblock(timeblock, timeblock_params) do
      render(conn, "show.json", timeblock: timeblock)
    end
  end

  def delete(conn, %{"id" => id}) do
    timeblock = TaskManager.get_timeblock!(id)
    with {:ok, %Timeblock{}} <- TaskManager.delete_timeblock(timeblock) do
      send_resp(conn, :no_content, "")
    end
  end
end
