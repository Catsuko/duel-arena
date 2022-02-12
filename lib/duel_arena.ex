defmodule DuelArena do

  def move(action_queue) do
    input = String.trim(IO.gets("\n"))
    DuelArena.ActionQueue.push(action_queue, {0, 0}, input)
    move(action_queue)
  end

end
