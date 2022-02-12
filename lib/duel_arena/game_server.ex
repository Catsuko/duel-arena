defmodule DuelArena.GameServer do
  use GenServer

  def init(%Tabletop.Board{} = board) do
    {:ok, board}
  end

  def handle_call({:take_turn, actions}, _from, board) do
    updated_board = Tabletop.take_turn(board, actions)
    {:reply, {:ok, updated_board}, updated_board}
  end

end
