defmodule DuelArena.ActionQueue do
  use GenServer

  def new(game_server) do
    {:ok, pid} = GenServer.start_link(DuelArena.ActionQueue, game_server)
    pid
  end

  def init(game_server) do
    :timer.send_interval(500, :tick)
    {:ok, {game_server, %{}}}
  end

  def push(pid, piece_id, move) do
    GenServer.cast(pid, {:push, piece_id, move})
    pid
  end

  def handle_info(:tick, {game_server, action_map}) do
    if Enum.any?(action_map) do
      GenServer.cast(game_server, format_actions_into_turn(action_map))
    end
    {:noreply, {game_server, %{}}}
  end

  def handle_cast({:push, piece_id, move}, {game_server, action_map}) do
    {:noreply, {game_server, Map.put(action_map, piece_id, move)}}
  end

  defp format_actions_into_turn(action_map) do
    actions = Enum.map action_map, fn {piece_id, dir} ->
      {:step, {piece_id, dir}}
    end
    {:take_turn, actions}
  end

end
