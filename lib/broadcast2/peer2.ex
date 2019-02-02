defmodule Peer2 do

  def start(id, broadcast) do
    receive do
    { :peers, peers } -> init_comps(id, broadcast, peers)
    end
  end

  defp init_comps(id, broadcast, peers) do
    pl_id = spawn(PL2, :start, [])
    com_id = spawn(Com2, :start, [id, peers])

    send pl_id, { :bind, com_id }
    send com_id, { :bind, pl_id }

    send broadcast, { :bind, self(), pl_id }

    receive do
    { :broadcast, max_broadcasts, timeout } ->
      send com_id, { :broadcast, max_broadcasts, timeout }
    end
  end


end
