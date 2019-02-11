# Hang Li Li (hl4716)

defmodule Com2 do

  def start(id, peers) do
    receive do
    { :bind, pl_id } ->
      receive do
      { :broadcast, max_broadcasts, timeout } ->
        counts = Map.new()
        Process.send_after(self(), { :timeout }, timeout)
        broadcast_msg(peers, max_broadcasts, counts, id, pl_id)
      end
    end
  end


  defp receive_msg(peers, max_broadcasts, counts, id, pl_id, max_acceptable_msgs) do
    if (0 < max_acceptable_msgs) do
      receive do
        # Updating messages received information.
        { :pl_deliver, from, _ } ->
          proc_info = Map.get(counts, from, {0, 0})
          msg_received = elem(proc_info, 1)
          counts = Map.put(counts, from, put_elem(proc_info, 1, msg_received + 1))
          receive_msg(peers, max_broadcasts, counts, id, pl_id, max_acceptable_msgs - 1)

        { :timeout } ->
          print(peers, counts, id)

      after
        1 -> broadcast_msg(peers, max_broadcasts, counts, id, pl_id)
      end

    else
      broadcast_msg(peers, max_broadcasts, counts, id, pl_id)
    end
  end


  defp broadcast_msg(peers, max_broadcasts, counts, id, pl_id) do
    counts = if (0 < max_broadcasts) do
      Enum.reduce(peers, counts, fn(dest_peer), acc ->
        send pl_id, { :pl_send, dest_peer, Enum.at(peers, id), "message" }
        proc_info = Map.get(acc, dest_peer, {0, 0})
        msg_sent = elem(proc_info, 0)
        Map.put(acc, dest_peer, put_elem(proc_info, 0, msg_sent + 1))
      end)
    else
      if receive_zeros(counts, peers) do
        IO.puts "Peer #{id} has finished broadcasting"
      end
      counts
    end

    max_broadcasts = if (0 < max_broadcasts) do
        max_broadcasts - 1
      else
        max_broadcasts
    end

    receive_msg(peers, max_broadcasts, counts, id, pl_id, length(peers))
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
