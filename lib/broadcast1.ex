defmodule Broadcast1 do

  def broadcast1() do
    max_broadcasts = 1000
    timeout = 3000

    peers = for n <- 0..4 do
      spawn(Peer1, :start, [n])
    end

    for peer <- peers do
      send peer, { :broadcast, max_broadcasts, timeout, peers }
    end
  end

  def broadcast1_net() do
    Process.sleep(5000)
    max_broadcasts = 1000
    timeout = 3000

    peers = for n <- 0..4 do
      Node.spawn(:'peer#{n}@peer#{n}.localdomain', Peer1, :start, [n])
    end

    for peer <- peers do
      send peer, { :broadcast, max_broadcasts, timeout, peers }
    end
  end

end
