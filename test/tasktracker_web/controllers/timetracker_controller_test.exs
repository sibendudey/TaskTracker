defmodule TasktrackerWeb.TimetrackerControllerTest do
  use TasktrackerWeb.ConnCase

  alias Tasktracker.TaskManager

  @create_attrs %{time: 42}
  @update_attrs %{time: 43}
  @invalid_attrs %{time: nil}

  def fixture(:timetracker) do
    {:ok, timetracker} = TaskManager.create_timetracker(@create_attrs)
    timetracker
  end

  describe "index" do
    test "lists all timetrackers", %{conn: conn} do
      conn = get conn, timetracker_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Timetrackers"
    end
  end

  describe "new timetracker" do
    test "renders form", %{conn: conn} do
      conn = get conn, timetracker_path(conn, :new)
      assert html_response(conn, 200) =~ "New Timetracker"
    end
  end

  describe "create timetracker" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, timetracker_path(conn, :create), timetracker: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == timetracker_path(conn, :show, id)

      conn = get conn, timetracker_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Timetracker"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, timetracker_path(conn, :create), timetracker: @invalid_attrs
      assert html_response(conn, 200) =~ "New Timetracker"
    end
  end

  describe "edit timetracker" do
    setup [:create_timetracker]

    test "renders form for editing chosen timetracker", %{conn: conn, timetracker: timetracker} do
      conn = get conn, timetracker_path(conn, :edit, timetracker)
      assert html_response(conn, 200) =~ "Edit Timetracker"
    end
  end

  describe "update timetracker" do
    setup [:create_timetracker]

    test "redirects when data is valid", %{conn: conn, timetracker: timetracker} do
      conn = put conn, timetracker_path(conn, :update, timetracker), timetracker: @update_attrs
      assert redirected_to(conn) == timetracker_path(conn, :show, timetracker)

      conn = get conn, timetracker_path(conn, :show, timetracker)
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, timetracker: timetracker} do
      conn = put conn, timetracker_path(conn, :update, timetracker), timetracker: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Timetracker"
    end
  end

  describe "delete timetracker" do
    setup [:create_timetracker]

    test "deletes chosen timetracker", %{conn: conn, timetracker: timetracker} do
      conn = delete conn, timetracker_path(conn, :delete, timetracker)
      assert redirected_to(conn) == timetracker_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, timetracker_path(conn, :show, timetracker)
      end
    end
  end

  defp create_timetracker(_) do
    timetracker = fixture(:timetracker)
    {:ok, timetracker: timetracker}
  end
end
