# ExFtp

Simple FTP client for Elixir.

'''elixir

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

