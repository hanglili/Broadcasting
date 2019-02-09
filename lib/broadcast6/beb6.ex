# Hang Li Li (hl4716)

defmodule BEB6 do
  # Basic broadcast

  def start(peers) do
    receive do
    { :bind, pl, c } ->
      next(peers, pl, c)
    end
  end

  defp next(peers, pl, c) do
    receive do
    { :beb_broadcast, message } ->
      for dest_peer <- peers do
        send pl, { :pl_send, dest_peer, message }
      end
    { :pl_deliver, message } ->
      send c, { :beb_deliver, message }
    end
    next(peers, pl, c)
  end

end
