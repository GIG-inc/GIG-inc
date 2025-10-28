defmodule Reminder do
  def main do
    response = spawn(fn -> Add.add(12,34) end)
    IO.puts("spawned process: #{inspect(response)}")
  end
end
