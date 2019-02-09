# Hang Li Li (hl4716)

defmodule LPL6 do

  def start() do
    receive do
      { :bind, beb_id } ->
      receive do
        { :pl_bind, pl_ids } ->
          next(beb_id, pl_ids, 100)
      end
    end
  end

  defp next(beb_id, pl_ids, reliability) do
    receive do
    { :pl_send, dest_peer, message } ->
      if :rand.uniform(100) > (100 - reliability) do
        send Map.get(pl_ids, dest_peer), { :network_deliver, message }
      end
    { :network_deliver, message } ->
      send beb_id, { :pl_deliver, message }
    end
    next(beb_id, pl_ids, reliability)
  end

end
