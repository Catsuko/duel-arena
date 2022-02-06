defmodule DuelArena.ActionQueue do
  use GenServer

  def init(game_server) do
    :timer.send_interval(1000, :tick)
    {:ok, {game_server, %{}}}
  end

  def push(pid, position, actions) when is_list(actions) do
    GenServer.cast(pid, {:push, position, actions})
    pid
  end

  def handle_info(:tick, {game_server, action_map}) do
    GenServer.cast(game_server, {:take_turn, action_map})
    {:noreply, {game_server, action_map}}
  end

  def handle_cast({:push, position, actions}, {game_server, action_map}) when is_list(actions) do
    total_actions = Map.get(action_map, position, []) ++ actions
    updated_map = Map.put(action_map, position, Enum.take(total_actions, -5))
    {:noreply, {game_server, updated_map}}
  end

end
