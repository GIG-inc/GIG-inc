defmodule Messagepassing.Example2 do
  def listen do
    receive do
      {:ok, _} -> IO.puts("world")
        # code
    end
    listen()
  end
end
