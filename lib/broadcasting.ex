defmodule Broadcasting do

  def main do
    [version, num_peers] = System.argv
    version = String.to_integer(version)
    num_peers = String.to_integer(num_peers)
    IO.puts "The version is #{version}"
    IO.puts "The number of peers is #{num_peers}"
    case version do
      1 -> Broadcast1.broadcast(num_peers)
      2 -> Broadcast2.broadcast(num_peers)
      3 -> Broadcast3.broadcast(num_peers)
      4 -> Broadcast4.broadcast(num_peers)
      5 -> Broadcast5.broadcast(num_peers)
      6 -> Broadcast6.broadcast(num_peers)
      _ -> IO.puts("Oops, you dont match!")
    end
  end

  def main_net do
    [version, num_peers] = System.argv
    version = String.to_integer(version)
    num_peers = String.to_integer(num_peers)
    IO.puts "The version is #{version}"
    IO.puts "The number of peers is #{num_peers}"
    case version do
      1 -> Broadcast1.broadcast_net(num_peers)
      2 -> Broadcast2.broadcast_net(num_peers)
      3 -> Broadcast3.broadcast_net(num_peers)
      4 -> Broadcast4.broadcast_net(num_peers)
      5 -> Broadcast5.broadcast_net(num_peers)
      6 -> Broadcast6.broadcast_net(num_peers)
      _ -> IO.puts("Oops, you dont match!")
    end
  end

end
