defmodule Broadcast4 do

  def broadcast() do
    max_broadcasts = 1000
    timeout = 3000
    num_peers = 5

    peers = for n <- 0..(num_peers - 1) do
      spawn(Peer4, :start, [n, self()])
    end

    for peer <- peers do
      send peer, { :peers, peers }
    end

    bind(peers, num_peers)

    for peer <- peers do
      send peer, { :broadcast, max_broadcasts, timeout }
    end
  end

  defp receive_bind(peers, num_peers, pl_ids) do
    if (num_peers <= 0) do
      pl_ids
    else
      receive do
      { :bind, process_id, pl_id } ->
        pl_ids = Map.put(pl_ids, process_id, pl_id)
        receive_bind(peers, num_peers - 1, pl_ids)
      end
    end
  end

  defp bind(peers, num_peers) do
    pl_ids = Map.new()
    pl_ids = receive_bind(peers, num_peers, pl_ids)
    for pl_id <- Map.values(pl_ids) do
      send pl_id, { :pl_bind, pl_ids }
    end
  end

  def broadcast_net do
    Process.sleep(10000)

    max_broadcasts = 1000
    timeout = 3000
    num_peers = 5

    peers = for n <- 0..(num_peers - 1) do
      Node.spawn(:'peer#{n}@peer#{n}.localdomain', Peer4, :start, [n, self()])
    end

    for peer <- peers do
      send peer, { :peers, peers }
    end

    bind(peers, num_peers)

    for peer <- peers do
      send peer, { :broadcast, max_broadcasts, timeout }
    end
  end

end
