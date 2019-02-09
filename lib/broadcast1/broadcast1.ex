# Hang Li Li (hl4716)

defmodule Broadcast1 do

  def broadcast(num_peers) do
    max_broadcasts = 1000
    timeout = 3000

    peers = for n <- 0..(num_peers - 1) do
      spawn(Peer1, :start, [n])
    end

    for peer <- peers do
      send peer, { :broadcast, max_broadcasts, timeout, peers }
    end
  end

  def broadcast_net(num_peers) do
    Process.sleep(5000)
    max_broadcasts = 1000
    timeout = 3000

    peers = for n <- 0..(num_peers - 1) do
      Node.spawn(:'peer#{n}@peer#{n}.localdomain', Peer1, :start, [n])
    end

    for peer <- peers do
      send peer, { :broadcast, max_broadcasts, timeout, peers }
    end
  end

end
