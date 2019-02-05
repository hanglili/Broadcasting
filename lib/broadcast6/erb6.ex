# Hang Li Li (hl4716)

defmodule ERB6 do
  # Basic broadcast

  def start() do
    receive do
    { :bind, beb, c } ->
      next(beb, c, MapSet.new())
    end
  end

  defp next(beb, c, delivered) do
    receive do
    { :rb_broadcast, from, m } ->
      send beb, { :beb_broadcast, from, { :rb_data, from, m } }
      next(beb, c, delivered)
    { :beb_deliver, from, { :rb_data, sender, m } = rb_m }->
      if m in delivered do
        next(beb, c, delivered)
      else
        send c, { :rb_deliver, sender, m }
        send beb, { :beb_broadcast, from, rb_m }
        next(beb, c, MapSet.put(delivered, m))
      end
    end
  end

end
