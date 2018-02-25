defmodule TasktrackerWeb.ManageControllerTest do
  use TasktrackerWeb.ConnCase

  alias Tasktracker.Accounts
  alias Tasktracker.Accounts.Manage

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  def fixture(:manage) do
    {:ok, manage} = Accounts.create_manage(@create_attrs)
    manage
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all manages", %{conn: conn} do
      conn = get conn, manage_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create manage" do
    test "renders manage when data is valid", %{conn: conn} do
      conn = post conn, manage_path(conn, :create), manage: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, manage_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, manage_path(conn, :create), manage: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update manage" do
    setup [:create_manage]

    test "renders manage when data is valid", %{conn: conn, manage: %Manage{id: id} = manage} do
      conn = put conn, manage_path(conn, :update, manage), manage: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, manage_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id}
    end

    test "renders errors when data is invalid", %{conn: conn, manage: manage} do
      conn = put conn, manage_path(conn, :update, manage), manage: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete manage" do
    setup [:create_manage]

    test "deletes chosen manage", %{conn: conn, manage: manage} do
      conn = delete conn, manage_path(conn, :delete, manage)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, manage_path(conn, :show, manage)
      end
    end
  end

  defp create_manage(_) do
    manage = fixture(:manage)
    {:ok, manage: manage}
  end
end
