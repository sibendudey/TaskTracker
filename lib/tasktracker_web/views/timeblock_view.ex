defmodule TasktrackerWeb.TimeblockView do
  use TasktrackerWeb, :view
  alias TasktrackerWeb.TimeblockView

  def render("index.json", %{timeblocks: timeblocks}) do
    %{data: render_many(timeblocks, TimeblockView, "timeblock.json")}
  end

  def render("show.json", %{timeblock: timeblock}) do
    %{data: render_one(timeblock, TimeblockView, "timeblock.json")}
  end

  def render("timeblock.json", %{timeblock: timeblock}) do
    %{id: timeblock.id,
      starttime: timeblock.starttime,
      endtime: timeblock.endtime}
  end
end
