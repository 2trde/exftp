defmodule FtpTest do
  use ExUnit.Case
  doctest ExFtp

  test "parse_ls" do
    list =
      """
      drwxr-xr-x   49 1000       ftpgroup         1666 Jan 11 10:02 TMBJJ9NE3E0068343
      drwxr-xr-x   46 1000       ftpgroup         1564 Jan 11 09:53 TMBJM6NJ2GZ103942
      drwxr-xr-x   61 1000       ftpgroup         2074 Jan 11 09:53 TMBKE61Z9C2176855
      """
      |> ExFtp.parse_ls()

    [
      %{name: "TMBJJ9NE3E0068343"},
      %{name: "TMBJM6NJ2GZ103942"},
      %{name: "TMBKE61Z9C2176855"}
    ] = list
  end

  test "parse_ls_line for name" do
    %{name: "TMBJJ9NE3E0068343"} =
      ExFtp.parse_ls_line(
        "drwxr-xr-x   49 1000       ftpgroup         1666 Jan 11 10:02 TMBJJ9NE3E0068343"
      )
  end

  test "parse_ls_line for directory" do
    %{type: :directory} =
      ExFtp.parse_ls_line(
        "drwxr-xr-x   49 1000       ftpgroup         1666 Jan 11 10:02 TMBJJ9NE3E0068343"
      )
  end

  test "parse_ls_line for file" do
    %{type: :file} =
      ExFtp.parse_ls_line(
        "-rwxr-xr-x   49 1000       ftpgroup         1666 Jan 11 10:02 TMBJJ9NE3E0068343"
      )
  end
end
