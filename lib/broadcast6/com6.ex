# Hang Li Li (hl4716)

defmodule Com6 do

  def start(id, peers) do
    receive do
    { :bind, erb_id } ->
      receive do
      { :broadcast, max_broadcasts, timeout } ->
        counts = Map.new()
        Process.send_after(self(), { :timeout }, timeout)
        next(peers, max_broadcasts, counts, id, 0, erb_id)
      end
    end
  end

  defp next(peers, max_broadcasts, counts, id, broadcast, erb_id) do
    receive do
    { :rb_deliver, from, message } ->
      proc_info = Map.get(counts, from, {0, 0})
      msg_received = elem(proc_info, 1)
      counts = Map.put(counts, from, put_elem(proc_info, 1, msg_received + 1))
      next(peers, max_broadcasts, counts, id, broadcast, erb_id)
    { :timeout } ->
      print(peers, counts, id)
    { :exit } ->
      print(peers, counts, id)
      Process.exit(self(), "Failure")

    after
      0 ->
        # Updating messages received information.
      counts = if (broadcast < max_broadcasts) do
        send erb_id, { :rb_broadcast, Enum.at(peers, id), "message#{id}#{broadcast}"}
        Enum.reduce(peers, counts, fn(dest_peer), acc ->
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
      next(peers, max_broadcasts, counts, id, broadcast, erb_id)
    end
  end

  defp print(peers, counts, id) do
    counts_string = Enum.reduce(peers, "", fn(peer), acc ->
      proc_info = Map.get(counts, peer, {0, 0})
      acc <> " " <> "{#{elem(proc_info, 0)}, #{elem(proc_info, 1)}} "
    end)
    IO.puts "Peer #{id}: #{counts_string}"
  end

end

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
