defmodule Peer4 do

  def start(id, broadcast) do
    receive do
    { :peers, peers } -> init_comps(id, broadcast, peers)
    end
  end

  defp init_comps(id, broadcast, peers) do
    pl_id = spawn(LPL4, :start, [])
    com_id = spawn(Com4, :start, [id, peers])
    beb_id = spawn(BEB4, :start, [peers])

    send pl_id, { :bind, beb_id }
    send com_id, { :bind, beb_id }
    send beb_id, { :bind, pl_id, com_id }

    send broadcast, { :bind, self(), pl_id }

    receive do
    { :broadcast, max_broadcasts, timeout } ->
      send com_id, { :broadcast, max_broadcasts, timeout }
    end
  end


end
