defmodule Broadcast2 do

  def broadcast2() do
    max_broadcasts = 1000
    timeout = 3000

    peers = for n <- 0..4 do
      spawn(Peer2, :start, [n, [], self()])
    end

    for i <- 0..4 do
      IO.puts "Index #{i} has process_id #{inspect Enum.at(peers, i)}"
    end

    for peer <- peers do
      send peer, { :broadcast, max_broadcasts, timeout }
    end

    receive_bind(peers)
  end

  defp receive_bind(peers) do
    receive do
      { :bind, process_id } ->
        bind(peers, process_id)
        receive_bind(peers)
    end
  end

  defp bind(peers, process_id) do
    for peer <- peers do
      send peer, { :bind, process_id }
      send process_id, { :bind, peer }
    end
  end

  def broadcast2_net do
    Process.sleep(10000)
    # peers = for n <- 0..9 do
    #   Node.spawn(:'peer#{n}@peer#{n}.localdomain', Peer, :start, [])
    # end
    #
    # for i <- 0..9 do
    #   IO.puts "Index #{i} has process_id #{inspect Enum.at(peers, i)}"
    # end
    #
    # bind(peers, 0, [1, 6])
    # bind(peers, 1, [0, 2, 3])
    # bind(peers, 2, [1, 3, 4])
    # bind(peers, 3, [1, 2, 5])
    # bind(peers, 4, [2])
    # bind(peers, 5, [3])
    # bind(peers, 6, [0, 7])
    # bind(peers, 7, [6, 8, 9])
    # bind(peers, 8, [7, 9])
    # bind(peers, 9, [7, 8])
    #
    # send List.first(peers), { :hello }
  end

end
