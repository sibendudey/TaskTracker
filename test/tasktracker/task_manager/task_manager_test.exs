defmodule Tasktracker.TaskManagerTest do
  use Tasktracker.DataCase

  alias Tasktracker.TaskManager

  describe "tasks" do
    alias Tasktracker.TaskManager.Task

    @valid_attrs %{completed: true, description: "some description", title: "some title"}
    @update_attrs %{completed: false, description: "some updated description", title: "some updated title"}
    @invalid_attrs %{completed: nil, description: nil, title: nil}

    def task_fixture(attrs \\ %{}) do
      {:ok, task} =
        attrs
        |> Enum.into(@valid_attrs)
        |> TaskManager.create_task()

      task
    end

    test "list_tasks/0 returns all tasks" do
      task = task_fixture()
      assert TaskManager.list_tasks() == [task]
    end

    test "get_task!/1 returns the task with given id" do
      task = task_fixture()
      assert TaskManager.get_task!(task.id) == task
    end

    test "create_task/1 with valid data creates a task" do
      assert {:ok, %Task{} = task} = TaskManager.create_task(@valid_attrs)
      assert task.completed == true
      assert task.description == "some description"
      assert task.title == "some title"
    end

    test "create_task/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = TaskManager.create_task(@invalid_attrs)
    end

    test "update_task/2 with valid data updates the task" do
      task = task_fixture()
      assert {:ok, task} = TaskManager.update_task(task, @update_attrs)
      assert %Task{} = task
      assert task.completed == false
      assert task.description == "some updated description"
      assert task.title == "some updated title"
    end

    test "update_task/2 with invalid data returns error changeset" do
      task = task_fixture()
      assert {:error, %Ecto.Changeset{}} = TaskManager.update_task(task, @invalid_attrs)
      assert task == TaskManager.get_task!(task.id)
    end

    test "delete_task/1 deletes the task" do
      task = task_fixture()
      assert {:ok, %Task{}} = TaskManager.delete_task(task)
      assert_raise Ecto.NoResultsError, fn -> TaskManager.get_task!(task.id) end
    end

    test "change_task/1 returns a task changeset" do
      task = task_fixture()
      assert %Ecto.Changeset{} = TaskManager.change_task(task)
    end
  end

  describe "timetrackers" do
    alias Tasktracker.TaskManager.Timetracker

    @valid_attrs %{time: 42}
    @update_attrs %{time: 43}
    @invalid_attrs %{time: nil}

    def timetracker_fixture(attrs \\ %{}) do
      {:ok, timetracker} =
        attrs
        |> Enum.into(@valid_attrs)
        |> TaskManager.create_timetracker()

      timetracker
    end

    test "list_timetrackers/0 returns all timetrackers" do
      timetracker = timetracker_fixture()
      assert TaskManager.list_timetrackers() == [timetracker]
    end

    test "get_timetracker!/1 returns the timetracker with given id" do
      timetracker = timetracker_fixture()
      assert TaskManager.get_timetracker!(timetracker.id) == timetracker
    end

    test "create_timetracker/1 with valid data creates a timetracker" do
      assert {:ok, %Timetracker{} = timetracker} = TaskManager.create_timetracker(@valid_attrs)
      assert timetracker.time == 42
    end

    test "create_timetracker/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = TaskManager.create_timetracker(@invalid_attrs)
    end

    test "update_timetracker/2 with valid data updates the timetracker" do
      timetracker = timetracker_fixture()
      assert {:ok, timetracker} = TaskManager.update_timetracker(timetracker, @update_attrs)
      assert %Timetracker{} = timetracker
      assert timetracker.time == 43
    end

    test "update_timetracker/2 with invalid data returns error changeset" do
      timetracker = timetracker_fixture()
      assert {:error, %Ecto.Changeset{}} = TaskManager.update_timetracker(timetracker, @invalid_attrs)
      assert timetracker == TaskManager.get_timetracker!(timetracker.id)
    end

    test "delete_timetracker/1 deletes the timetracker" do
      timetracker = timetracker_fixture()
      assert {:ok, %Timetracker{}} = TaskManager.delete_timetracker(timetracker)
      assert_raise Ecto.NoResultsError, fn -> TaskManager.get_timetracker!(timetracker.id) end
    end

    test "change_timetracker/1 returns a timetracker changeset" do
      timetracker = timetracker_fixture()
      assert %Ecto.Changeset{} = TaskManager.change_timetracker(timetracker)
    end
  end

  describe "timeblocks" do
    alias Tasktracker.TaskManager.Timeblock

    @valid_attrs %{endtime: "2010-04-17 14:00:00.000000Z", starttime: "2010-04-17 14:00:00.000000Z"}
    @update_attrs %{endtime: "2011-05-18 15:01:01.000000Z", starttime: "2011-05-18 15:01:01.000000Z"}
    @invalid_attrs %{endtime: nil, starttime: nil}

    def timeblock_fixture(attrs \\ %{}) do
      {:ok, timeblock} =
        attrs
        |> Enum.into(@valid_attrs)
        |> TaskManager.create_timeblock()

      timeblock
    end

    test "list_timeblocks/0 returns all timeblocks" do
      timeblock = timeblock_fixture()
      assert TaskManager.list_timeblocks() == [timeblock]
    end

    test "get_timeblock!/1 returns the timeblock with given id" do
      timeblock = timeblock_fixture()
      assert TaskManager.get_timeblock!(timeblock.id) == timeblock
    end

    test "create_timeblock/1 with valid data creates a timeblock" do
      assert {:ok, %Timeblock{} = timeblock} = TaskManager.create_timeblock(@valid_attrs)
      assert timeblock.endtime == DateTime.from_naive!(~N[2010-04-17 14:00:00.000000Z], "Etc/UTC")
      assert timeblock.starttime == DateTime.from_naive!(~N[2010-04-17 14:00:00.000000Z], "Etc/UTC")
    end

    test "create_timeblock/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = TaskManager.create_timeblock(@invalid_attrs)
    end

    test "update_timeblock/2 with valid data updates the timeblock" do
      timeblock = timeblock_fixture()
      assert {:ok, timeblock} = TaskManager.update_timeblock(timeblock, @update_attrs)
      assert %Timeblock{} = timeblock
      assert timeblock.endtime == DateTime.from_naive!(~N[2011-05-18 15:01:01.000000Z], "Etc/UTC")
      assert timeblock.starttime == DateTime.from_naive!(~N[2011-05-18 15:01:01.000000Z], "Etc/UTC")
    end

    test "update_timeblock/2 with invalid data returns error changeset" do
      timeblock = timeblock_fixture()
      assert {:error, %Ecto.Changeset{}} = TaskManager.update_timeblock(timeblock, @invalid_attrs)
      assert timeblock == TaskManager.get_timeblock!(timeblock.id)
    end

    test "delete_timeblock/1 deletes the timeblock" do
      timeblock = timeblock_fixture()
      assert {:ok, %Timeblock{}} = TaskManager.delete_timeblock(timeblock)
      assert_raise Ecto.NoResultsError, fn -> TaskManager.get_timeblock!(timeblock.id) end
    end

    test "change_timeblock/1 returns a timeblock changeset" do
      timeblock = timeblock_fixture()
      assert %Ecto.Changeset{} = TaskManager.change_timeblock(timeblock)
    end
  end
end
