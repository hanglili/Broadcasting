defmodule Peer6 do

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
    pl_id = spawn(LPL6, :start, [])
    com_id = spawn(Com6, :start, [id, peers])
    beb_id = spawn(BEB6, :start, [peers])
    erb_id = spawn(ERB6, :start, [])

    send pl_id, { :bind, beb_id }
    send com_id, { :bind, erb_id }
    send beb_id, { :bind, pl_id, erb_id }
    send erb_id, { :bind, beb_id, com_id }

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
      # Process.exit(com_id, "Failure")
      send com_id, { :exit }
      Process.exit(self(), "Failure")
    end
  end


end
