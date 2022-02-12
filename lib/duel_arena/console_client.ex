defmodule DuelArena.ConsoleClient do

  def main() do
    board = Tabletop.Board.square(4)
      |> Tabletop.Actions.apply(:add, {Tabletop.Piece.new("X"), {0, 0}})
    {:ok, game_server_pid} = GenServer.start_link(DuelArena.GameServer, board)
    {:ok, view_pid} = GenServer.start_link(DuelArena.ConsoleView, game_server_pid)
    {:ok, action_queue_pid} = GenServer.start_link(DuelArena.ActionQueue, view_pid)
    get_input(action_queue_pid)
  end

  def get_input(action_queue_pid) do
    direction = get_direction()
    DuelArena.ActionQueue.push(action_queue_pid, "X", direction)
    get_input(action_queue_pid)
  end

  # TODO: Fix rendering so these directions make sense
  defp get_direction() do
    case String.trim(IO.gets("\n")) do
      "l" ->
        {0, -1}
      "r" ->
        {0, 1}
      "u" ->
        {-1, 0}
      "d" ->
        {1, 0}
      _ ->
        IO.puts("invalid input, use: 'l', 'r', 'u', 'd'")
        get_direction()
    end
  end

end
