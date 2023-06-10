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

  test "parse_ls filename with spaces" do
    list =
      """
      drwxr-xr-x   49 1000       ftpgroup         1666 Jan 11 10:02 Foo Bar1.jpg
      drwxr-xr-x   49 1000       ftpgroup         1666 Jan 11 10:02 Foo Bar2.jpg
      """
      |> ExFtp.parse_ls()

    [
      %{name: "Foo Bar1.jpg"},
      %{name: "Foo Bar2.jpg"},
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

  test "parse_ls_line for last year" do
    %{name: "15555555555555555", type: :file} =
      ExFtp.parse_ls_line(
          "drwx------    2 1040     100          4096 Aug 22  2022 15555555555555555"
      )
  end
end
