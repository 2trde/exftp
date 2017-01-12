defmodule ExFtp do
  @doc """
  Open connection to ftp by passing hostname, user and password.
  Returns the pid that has to be passed to execute commands on that connection
  """
  def open(host, user, password) do
    :inets.start
    {:ok, pid} = :inets.start(:ftpc, host: host |> String.to_charlist, mode: :active)
    :ok = :ftp.user(pid, user |> String.to_charlist, password |> String.to_charlist)
    pid
  end

  @doc """
  returns the current working directory
  """
  def pwd(pid) do
    :ftp.pwd(pid) |> List.to_string
  end

  @doc """
  change directory
  """
  def cd(pid, path) do
    :ftp.cd(pid, path |> String.to_charlist)
  end

  @doc """
  list files in directory
  will return an list of %{file: filename, type: :directory|:file}
  """
  def ls(pid) do
    {:ok, listing} = :ftp.ls(pid)
    parse_ls(listing |> List.to_string)
  end

  @doc """
  close the connection
  """
  def close(pid) do
    :inets.stop(:ftpc, pid)
  end


  def parse_ls(raw) do
    raw
    |> String.split("\n")
    |> Enum.map(&String.trim/1)
    |> Enum.filter(fn (s) -> (String.length(s) > 0) end)
    |> Enum.map(&parse_ls_line/1)
  end

  def parse_ls_line(line) do
    ~r/([di-])[rwx-]{9,9}.+ (.+)/
    |> Regex.run(line)
    |> parse_ls_line(line)
  end
  def parse_ls_line([_all, type, name], _line) do
    %{
      name: name,
      type: case type do
              "d" -> :directory
              _ -> :file
            end
    }
  end
  def parse_ls_line(nil, line) do
    raise "failed to parse ftp ls line: #{line}"
  end

  def parse_time(timestr) do
    {:ok, datetime} = Timex.parse(timestr, "{YYYY} {Mshort} {D} {h24}:{m}")
    datetime
  end
end
