# Hang Li Li (hl4716)

defmodule Broadcast3 do

  def broadcast(num_peers) do
    max_broadcasts = 110000
    timeout = 300

    ids = Enum.to_list(0..(num_peers - 1))

    peers = for n <- ids do
      spawn(Peer3, :start, [n, self(), ids])
    end

    bind(num_peers)

    for peer <- peers do
      send peer, { :broadcast, max_broadcasts, timeout }
    end
  end

  defp receive_bind(num_peers, pl_ids) do
    if (num_peers <= 0) do
      pl_ids
    else
      receive do
      { :bind, id, pl_id } ->
        pl_ids = Map.put(pl_ids, id, pl_id)
        receive_bind(num_peers - 1, pl_ids)
      end
    end
  end

  defp bind(num_peers) do
    pl_ids = Map.new()
    pl_ids = receive_bind(num_peers, pl_ids)
    for pl_id <- Map.values(pl_ids) do
      send pl_id, { :pl_bind, pl_ids }
    end
  end

  def broadcast_net(num_peers) do
    Process.sleep(5000)

    max_broadcasts = 13500
    timeout = 500

    ids = Enum.to_list(0..(num_peers - 1))

    peers = for n <- ids do
      Node.spawn(:'peer#{n}@peer#{n}.localdomain', Peer3, :start, [n, self(), ids])
    end

    bind(num_peers)

    for peer <- peers do
      send peer, { :broadcast, max_broadcasts, timeout }
    end
  end

end
