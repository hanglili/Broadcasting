# Hang Li Li (hl4716)

defmodule Peer4 do

  def start(id, broadcast, ids) do
    pl_id = spawn(LPL4, :start, [])
    com_id = spawn(Com4, :start, [id, ids])
    beb_id = spawn(BEB4, :start, [ids])

    send pl_id, { :bind, beb_id }
    send com_id, { :bind, beb_id }
    send beb_id, { :bind, pl_id, com_id }

    send broadcast, { :bind, id, pl_id }

    receive do
    { :broadcast, max_broadcasts, timeout } ->
      send com_id, { :broadcast, max_broadcasts, timeout }
    end
  end


end
