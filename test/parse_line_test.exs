defmodule ExFtp.ParseLineTest do
  use ExUnit.Case
  import ExFtp.ParseLine

  test "parse_ls_line for name" do
    assert {:ok, %{name: "TMBJJ9NE3E0068343"}} =
      parse(
        "drwxr-xr-x   49 1000       ftpgroup         1666 Jan 11 10:02 TMBJJ9NE3E0068343"
      )
  end

  test "parse_ls_line for directory" do
    assert {:ok, %{type: :directory}} =
      parse(
        "drwxr-xr-x   49 1000       ftpgroup         1666 Jan 11 10:02 TMBJJ9NE3E0068343"
      )
  end

  test "parse_ls_line for file" do
    assert {:ok, %{type: :file}} =
      parse(
        "-rwxr-xr-x   49 1000       ftpgroup         1666 Jan 11 10:02 TMBJJ9NE3E0068343"
      )
      |> IO.inspect
  end

  test "parse_ls_line for last year" do
    assert {:ok, %{name: "15555555555555555", type: :directory}} =
      parse(
          "drwx------    2 1040     100          4096 Aug 22  2022 15555555555555555"
      )
  end

end
