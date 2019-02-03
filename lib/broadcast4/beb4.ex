defmodule BEB4 do
  # Basic broadcast

  def start(peers) do
    receive do
    { :bind, pl, c } ->
      next(peers, pl, c)
    end
  end

  defp next(peers, pl, c) do
    receive do
    { :beb_broadcast, from, message } ->
      for dest_peer <- peers do
        send pl, { :pl_send, dest_peer, from, message }
      end
    { :pl_deliver, from, message } ->
      send c, { :beb_deliver, from, message }
    end
    next(peers, pl, c)
  end

end
