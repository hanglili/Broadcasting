# Hang Li Li (hl4716)

defmodule Peer2 do

  def start(id, broadcast, ids) do
    pl_id = spawn(PL2, :start, [])
    com_id = spawn(Com2, :start, [id, ids])

    send pl_id, { :bind, com_id }
    send com_id, { :bind, pl_id }

    send broadcast, { :bind, id, pl_id }

    receive do
    { :broadcast, max_broadcasts, timeout } ->
      send com_id, { :broadcast, max_broadcasts, timeout }
    end
  end

end
