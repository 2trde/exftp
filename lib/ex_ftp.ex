defmodule ExFtp do
  @doc """
  Open connection to ftp by passing hostname, user and password.
  Returns the pid that has to be passed to execute commands on that connection
  """
  def open(host, user, password, options \\ []) do
    :inets.start
    {:ok, pid} = :inets.start(:ftpc, Keyword.merge(options, [host: host |> String.to_charlist]))
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
  def cd(pid, path, create_if_not_exists \\ false) do
    IO.puts "create_if_not_exists: #{create_if_not_exists}"
    if create_if_not_exists do
      ensure_dir(pid, path)
    end

    :ftp.cd(pid, path |> String.to_charlist)
  end

  def ensure_dir(pid, dir) when is_binary(dir) do
    parts = dir |> String.split("/") |> Enum.filter(&(&1 != "")) |> Enum.reverse
    ensure_dir(pid, parts)
  end

  def ensure_dir(pid, dir) when is_list(dir) do
    IO.puts "ensure_dir: #{inspect list_to_dir(dir)}"
    [leaf | parent] = dir

    if length(parent) > 0 do
      ensure_dir(pid, parent)
    end
    cd(pid, list_to_dir(dir))
    |> case do
      :ok ->
        :ok
      {:error, _} ->
        IO.puts "mkdir: #{inspect list_to_dir(dir)}"
        :ok = mkdir(pid, list_to_dir(dir))
    end
  end

  defp list_to_dir(list) do
    base =
      list
      |> Enum.reverse
      |> Enum.join("/")

    ("/" <> base)
  end


  @doc """
  create directory
  """
  def mkdir(pid, path) do
    :ftp.mkdir(pid, path |> String.to_charlist)
  end

  @doc """
  list files in directory
  will return an list of %{name: filename, type: :directory|:file}
  """
  def ls(pid) do
    {:ok, listing} = :ftp.ls(pid)
    parse_ls(listing |> List.to_string)
  end

  @doc """
  getrieve a file
  will return {:ok, binary} or {:error, reason}
  """
  def get(pid, filename) do
    :ftp.type(pid, :binary)
    result = :ftp.recv_bin(pid, filename |> String.to_charlist)
    :ftp.type(pid, :ascii)
    result
  end


  @doc """
  put a file
  will return :ok or {:error, reason}
  """
  def put(pid, binary, filename) do
    :ftp.type(pid, :binary)
    result = :ftp.send_bin(pid, binary, filename |> String.to_charlist)
    :ftp.type(pid, :ascii)
    result
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
