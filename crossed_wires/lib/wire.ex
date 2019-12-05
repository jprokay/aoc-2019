defmodule Wire do
	
	def signal_delay(wire, point) do
		wire
		|> Enum.reverse
		|> Enum.reduce_while(0, fn x, acc -> calc_signal_delay(x, point, acc) end)
	end

	defp calc_signal_delay(line, point, acc) do
		if Line.contains?(line, point) do
			{:halt, acc + Line.distance_to_point(line, point)}
		else
			{:cont, acc + Map.fetch!(line, :value)}
		end
	end
end