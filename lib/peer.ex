defmodule Peer do

  def start(id) do
    # Map from a process_id to a tuple of 2 elements(msgs broadcast, msgs received)
    broadcast = 0
    receive do
    { :broadcast, max_broadcasts, timeout, peers } ->
      counts = Enum.reduce(peers, %{}, fn(peer), acc ->
        Map.put(acc, peer, {0, 0})
      end)
      next(peers, max_broadcasts, timeout, counts, id, broadcast)
    end
  end

  defp next(peers, max_broadcasts, timeout, counts, id, broadcast) do
      # Updating messages received information.
    counts = if (broadcast < max_broadcasts) do
      Enum.reduce(peers, counts, fn(peer), acc ->
        send peer, { :hello, self() }
        proc_info = Map.get(acc, peer)
        msg_sent = elem(proc_info, 0)
        Map.replace!(acc, peer, put_elem(proc_info, 0, msg_sent + 1))
      end) else
      counts
    end
    broadcast = if (broadcast < max_broadcasts) do broadcast + 1 else broadcast end
    receive do
    { :hello, sender } ->
      proc_info = Map.get(counts, sender)
      msg_received = elem(proc_info, 1)
      counts = Map.replace!(counts, sender, put_elem(proc_info, 1, msg_received + 1))
      next(peers, max_broadcasts, timeout, counts, id, broadcast)
    after
      timeout ->
        counts_string = Enum.reduce(peers, "", fn(peer), acc ->
          proc_info = Map.get(counts, peer)
          acc <> " " <> "{#{elem(proc_info, 0)}, #{elem(proc_info, 1)}} "
        end)
        IO.puts "Peer #{id}: #{counts_string}"
    end
  end

end
