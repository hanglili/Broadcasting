defmodule Peer5 do

  def start(id, broadcast) do
    # Terminate itself
    if (id == 3) do
      Process.send_after(self(), { :exit }, 5)
    end

    receive do
    { :peers, peers } -> init_comps(id, broadcast, peers)
    end
  end

  defp init_comps(id, broadcast, peers) do
    pl_id = spawn(LPL5, :start, [])
    com_id = spawn(Com5, :start, [id, peers])
    beb_id = spawn(BEB5, :start, [peers])

    send pl_id, { :bind, beb_id }
    send com_id, { :bind, beb_id }
    send beb_id, { :bind, pl_id, com_id }

    send broadcast, { :bind, self(), pl_id }

    receive do
    { :broadcast, max_broadcasts, timeout } ->
      send com_id, { :broadcast, max_broadcasts, timeout }
      next(pl_id, beb_id, com_id)
    end
  end

  defp next(pl_id, beb_id, com_id) do
    receive do
    { :exit } ->
      Process.exit(pl_id, "Failure")
      Process.exit(beb_id, "Failure")
      Process.exit(com_id, "Failure")
      Process.exit(self(), "Failure")
    end
  end


end
