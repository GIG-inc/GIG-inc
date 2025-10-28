# this is if we want to be informed that a process has failed but we do not want the current process to fail
defmodule Processmonitoring.Main do
  def explode do
    exit("because i fucking said so")
  end

  def run do
    spawn_monitor(Processmonitoring.Main, :explode, [])

    receive do
      {:DOWN,_ref,:process, _from_pid,reason} -> IO.puts("Exit reason #{reason}")
    end
  end
end
