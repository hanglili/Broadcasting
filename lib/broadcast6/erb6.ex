# Hang Li Li (hl4716)

defmodule ERB6 do
  # Basic broadcast

  def start(id) do
    receive do
    { :bind, beb, c } ->
      next(beb, c, MapSet.new(), id)
    end
  end

  defp next(beb, c, delivered, id) do
    receive do
    { :rb_broadcast, m } ->
      send beb, { :beb_broadcast, { :rb_data, id, m } }
      next(beb, c, delivered, id)
    { :beb_deliver, { :rb_data, sender, m } = rb_m }->
      if m in delivered do
        next(beb, c, delivered, id)
      else
        send c, { :rb_deliver, sender, m }
        send beb, { :beb_broadcast, rb_m }
        next(beb, c, MapSet.put(delivered, m), id)
      end
    end
  end

end
