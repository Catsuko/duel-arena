defmodule DuelArena.ActionQueueTest do
  use ExUnit.Case

  describe "push" do
    test "adds actions to queue when none exist" do
      {:noreply, {_, actions_map}} = DuelArena.ActionQueue.handle_cast(
        {:push, 1, [1]}, {1, %{}}
      )
      assert [1] = Map.fetch!(actions_map, 1)
    end

    test "adds actions to queue when some exist" do
      {:noreply, {_, actions_map}} = DuelArena.ActionQueue.handle_cast(
        {:push, 1, [1]}, {1, %{1 => [3, 2]}}
      )
      assert [3, 2, 1] = Map.fetch!(actions_map, 1)
    end

    test "drops older actions when there are too many" do
      {:noreply, {_, actions_map}} = DuelArena.ActionQueue.handle_cast(
        {:push, 1, [2, 3]}, {1, %{1 => [5, 4, 3, 2, 1]}}
      )
      assert [3, 2, 1, 2, 3] = Map.fetch!(actions_map, 1)
    end

    test "does not store more than the maximum actions" do
      {:noreply, {_, actions_map}} = DuelArena.ActionQueue.handle_cast(
        {:push, 1, [2, 3, 4, 5, 6, 7, 8, 9, 10]}, {1, %{1 => [1]}}
      )
      assert [6, 7, 8, 9, 10] = Map.fetch!(actions_map, 1)
    end
  end

end
