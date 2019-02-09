# Hang Li Li (hl4716)

defmodule Peer1 do

  def start(id) do
    # Map from a process_id to a tuple of 2 elements(msgs broadcast, msgs received)
    receive do
      { :broadcast, max_broadcasts, timeout, peers } ->
        counts = Map.new()
        Process.send_after(self(), { :timeout }, timeout)
        next(peers, max_broadcasts, counts, id)
    end
  end

  defp receive_msgs(peers, max_broadcasts, counts, id, max_acceptable_msgs) do
    if (0 < max_acceptable_msgs) do
      receive do
        { :network_deliver, from, _ } ->
          # Updating messages received information.
          proc_info = Map.get(counts, from, {0, 0})
          msg_received = elem(proc_info, 1)
          counts = Map.put(counts, from, put_elem(proc_info, 1, msg_received + 1))
          receive_msgs(peers, max_broadcasts, counts, id, max_acceptable_msgs - 1)

        { :timeout } ->
          print(peers, counts, id)

      after
        1 -> broadcast_to_peers(peers, max_broadcasts, counts, id)
      end

    else
      broadcast_to_peers(peers, max_broadcasts, counts, id)
    end
  end

  defp next(peers, max_broadcasts, counts, id) do
    receive_msgs(peers, max_broadcasts, counts, id, 5)
  end

  defp broadcast_to_peers(peers, max_broadcasts, counts, id) do
    counts = if (0 < max_broadcasts) do
      Enum.reduce(peers, counts, fn(dest_peer), acc ->
        send dest_peer, { :network_deliver, self(), "message" }
        proc_info = Map.get(acc, dest_peer, {0, 0})
        msg_sent = elem(proc_info, 0)
        Map.put(acc, dest_peer, put_elem(proc_info, 0, msg_sent + 1))
      end)
    else
      if receive_zeros(counts, peers) do
        IO.puts "Peer #{id} has terminated"
      end
      counts
    end

    max_broadcasts = if (0 < max_broadcasts) do
      max_broadcasts - 1
    else
      max_broadcasts
    end

    next(peers, max_broadcasts, counts, id)
  end

  defp print(peers, counts, id) do
    counts_string = Enum.reduce(peers, "", fn(peer), acc ->
      proc_info = Map.get(counts, peer, {0, 0})
      acc <> " " <> "{#{elem(proc_info, 0)}, #{elem(proc_info, 1)}} "
    end)
    IO.puts "Peer #{id}: #{counts_string}"
  end

  defp receive_zeros(counts, peers) do
    Enum.reduce(peers, true, fn(peer), acc ->
      proc_info = Map.get(counts, peer, {0, 0})
      acc and (elem(proc_info, 1) == 0)
    end)
  end

end

# counts = Enum.reduce(peers, %{}, fn(peer), acc ->
#   Map.put(acc, peer, {0, 0})
# end)
