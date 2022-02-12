defmodule DuelArena.ConsoleView do
  use GenServer

  def init(game_server) do
    {:ok, game_server}
  end

  def handle_cast(message, game_server) do
    {:ok, board} = GenServer.call(game_server, message)
    render_board(board)
    {:noreply, game_server}
  end

  defp render_board(%Tabletop.Board{pieces: pieces} = board) do
    squares = Enum.map pieces, fn {_pos, piece} ->
      case piece do
        %Tabletop.Piece{id: id} ->
          id
        _ ->
          "-"
      end
    end

    board_string = Enum.chunk_every(squares, 4)
      |> Enum.map(&Enum.join/1)
      |> List.flatten
      |> Enum.join("\n")

    IO.puts("\n" <> board_string <> "\n")
    board
  end
end
