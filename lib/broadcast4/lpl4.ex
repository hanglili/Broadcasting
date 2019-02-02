defmodule LPL4 do

  def start() do
    receive do
      { :bind, beb_id } ->
      receive do
        { :pl_bind, pl_ids } ->
          next(beb_id, pl_ids, 50)
      end
    end
  end

  defp next(beb_id, pl_ids, reliability) do
    receive do
    { :pl_send, dest_peer, from, message } ->
      if Enum.random(1..100) > (100 - reliability) do
        send Map.get(pl_ids, dest_peer), { :network_deliver, from, message }
      end
    { :network_deliver, from, message } ->
      # if Enum.random(1..100) > (100 - reliability) do
        send beb_id, { :pl_deliver, from, message }
      # end
    end
    next(beb_id, pl_ids, reliability)
  end

end
