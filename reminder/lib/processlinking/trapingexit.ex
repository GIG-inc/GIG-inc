# this is for when we want when one process fails the other processes related to it fail too
defmodule Processlinking.Trapingexit do
  def explode do
    exit("because i said so")
  end
  def run do
    Process.flag(:trap_exit, true)
    spawn_link(Processlinking.Trapingexit, :explode, [])

    receive do
      {:EXIT,_from_pid,reason} -> IO.puts("Exit reason: #{reason}")
        # code
    end
  end
end
