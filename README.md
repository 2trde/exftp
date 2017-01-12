# ExFtp

Simple FTP client for Elixir.

Use like this:
'''elixir
  pid = ExFtp.open("ftp.targetdomain.com", "foo_user", "bar_password")
  ExFtp.cd(pid, "/mydir")
  list = ExFtp.ls()

  assert list == [%{name: "foobar.txt", type: :file}, %{name: "subdir", type: :directory}]
'''

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add `ftp` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:exftp, github: 'mlankenau/exftp'}]
    end
    ```

  2. Ensure `ftp` is started before your application:

    ```elixir
    def application do
      [applications: [:exftp]]
    end
    ```

