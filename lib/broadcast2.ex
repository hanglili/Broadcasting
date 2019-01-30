defmodule Broadcast2 do

  def broadcast2() do
    max_broadcasts = 1000
    timeout = 3000
    
    peers = for n <- 0..4 do
      spawn(Peer2, :start, [n, []])
    end

    for i <- 0..4 do
      IO.puts "Index #{i} has process_id #{inspect Enum.at(peers, i)}"
    end

    receive do
      { :bind, process_id } -> bind(peers, process_id)
    end

    for peer <- peers do
      send peer, { :broadcast, max_broadcasts, timeout, peers }
    end
  end

  defp bind(peers, process_id) do
    for peer <- peers do
      send peer, { :bind, process_id }
    end
  end

  # def main_net do
  #   Process.sleep(10000)
  #   peers = for n <- 0..9 do
  #     Node.spawn(:'peer#{n}@peer#{n}.localdomain', Peer, :start, [])
  #   end
  #
  #   for i <- 0..9 do
  #     IO.puts "Index #{i} has process_id #{inspect Enum.at(peers, i)}"
  #   end
  #
  #   bind(peers, 0, [1, 6])
  #   bind(peers, 1, [0, 2, 3])
  #   bind(peers, 2, [1, 3, 4])
  #   bind(peers, 3, [1, 2, 5])
  #   bind(peers, 4, [2])
  #   bind(peers, 5, [3])
  #   bind(peers, 6, [0, 7])
  #   bind(peers, 7, [6, 8, 9])
  #   bind(peers, 8, [7, 9])
  #   bind(peers, 9, [7, 8])
  #
  #   send List.first(peers), { :hello }
  # end

end
