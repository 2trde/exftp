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


  test "spaces in filename" do
    assert {:ok, %{name: "DAT-VIN Datenblatt.pdf", type: :file, timestamp: ~U[2023-09-18 15:23:00Z]}} =
      parse(
          "-rw-rw-r--    1 1004     1004       146786 Sep 18 15:23 DAT-VIN Datenblatt.pdf"
      )
  end

  test "parenthesis in filename" do
    assert {:ok, %{name: "066ZA0172101 (1).pdf", timestamp: ~U[2023-09-18 15:23:00Z], type: :file}} =
      parse(
          "-rw-rw-r--    1 1004     1004       146101 Sep 18 15:23 066ZA0172101 (1).pdf"
      )
  end

end
