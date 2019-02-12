# Hang Li Li (hl4716)

defmodule PL3 do

  def start() do
    receive do
      { :bind, beb_id } ->
      receive do
        # pl_ids is a map that maps from a peer id to its pl process id.
        { :pl_bind, pl_ids } ->
          next(beb_id, pl_ids)
      end
    end
  end

  defp next(beb_id, pl_ids) do
    receive do
    { :pl_send, dest_peer, from, message } ->
      send Map.get(pl_ids, dest_peer), { :network_deliver, from, message }
    { :network_deliver, from, message } ->
      send beb_id, { :pl_deliver, from, message }
    end
    next(beb_id, pl_ids)
  end

end
