# Hang Li Li (hl4716)

defmodule Peer1 do

  def start(id) do
    # Map from a process_id to a tuple of 2 elements(msgs broadcast, msgs received)
    receive do
    { :broadcast, max_broadcasts, timeout, peers } ->
      counts = Map.new()
      Process.send_after(self(), { :timeout }, timeout)
      next(peers, max_broadcasts, counts, id, 0)
    end
  end

  defp next(peers, max_broadcasts, counts, id, broadcast) do
    receive do
    { :network_deliver, from, message } ->
      proc_info = Map.get(counts, from, {0, 0})
      msg_received = elem(proc_info, 1)
      counts = Map.put(counts, from, put_elem(proc_info, 1, msg_received + 1))
      next(peers, max_broadcasts, counts, id, broadcast)
    { :timeout } ->
      print(peers, counts, id)

    after
    0 ->
        # Updating messages received information.
      counts = if (broadcast < max_broadcasts) do
        Enum.reduce(peers, counts, fn(dest_peer), acc ->
          send dest_peer, { :network_deliver, self(), "message" }
          proc_info = Map.get(acc, dest_peer, {0, 0})
          msg_sent = elem(proc_info, 0)
          Map.put(acc, dest_peer, put_elem(proc_info, 0, msg_sent + 1))
        end)
      else
        counts
      end
      broadcast = if (broadcast < max_broadcasts) do
        broadcast + 1
      else
        broadcast
      end
      next(peers, max_broadcasts, counts, id, broadcast)
      #
      # if (broadcast < max_broadcasts) do
      #   next(peers, max_broadcasts, counts, id, broadcast + 1)
      # else
      #   counts_string = Enum.reduce(peers, "", fn(peer), acc ->
      #     proc_info = Map.get(counts, peer)
      #     acc <> " " <> "{#{elem(proc_info, 0)}, #{elem(proc_info, 1)}} "
      #   end)
      #   IO.puts "Peer #{id}: #{counts_string}"
      # end
    end
  end

  defp print(peers, counts, id) do
    counts_string = Enum.reduce(peers, "", fn(peer), acc ->
      proc_info = Map.get(counts, peer)
      acc <> " " <> "{#{elem(proc_info, 0)}, #{elem(proc_info, 1)}} "
    end)
    IO.puts "Peer #{id}: #{counts_string}"
  end

end

# counts = Enum.reduce(peers, %{}, fn(peer), acc ->
#   Map.put(acc, peer, {0, 0})
# end)
