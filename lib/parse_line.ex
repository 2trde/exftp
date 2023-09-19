defmodule ExFtp.ParseLine do
  use ExLR

  terminal :permissions, chars: [?d, ?r, ?w, ?x, ?-], min: 10, max: 10, prio: 0
  terminal :time, chars: [?0, ?1, ?2, ?3, ?4, ?5, ?6, ?7, ?8, ?9, ?:], min: 5, max: 5, prio: 0
  terminal :string, chars: [?a..?z, ?A..?Z, ?0..?9, ?., ?-, ?_], prio: 1

  lr skip_whitespaces: true do
    # drwxr-xr-x   49 1000       ftpgroup         1666 Jan 11 10:02 TMBJJ9NE3E0068343
    Line <- :permissions + :integer + User + User + Size + DateTime + Filename = fn
      [perm, _, _user, _group, _size, ts, name] ->
        %{
          name: name,
          timestamp: ts,
          type: if(perm |> String.starts_with?("d"), do: :directory, else: :file),
        }
    end

    Filename <- :integer = fn [i] -> "#{i}" end
    Filename <- :string = fn [name] -> name  end
    Filename <- Filename + :string = fn [name1, name2] -> name1 <> " " <> name2 end

    User <- :integer
    User <- :string = fn [u] -> u end

    Size <- :integer

    DateTime <- Month + :integer + Time    = fn [mon, d, {h, m}] ->
      {:ok, %{year: year}} = DateTime.now("Etc/UTC")
      %DateTime{
        calendar: Calendar.ISO,
        day: d,
        month: mon,
        year: year,
        hour: h,
        minute: m,
        second: 0,
        std_offset: 0, time_zone: "Etc/UTC", utc_offset: 0,zone_abbr: "UTC"
      }
    end

    DateTime <- Month + :integer + :integer = fn [m, d, y] ->
      %DateTime{
        calendar: Calendar.ISO,
        day: d,
        month: m,
        year: y,
        hour: 0,
        minute: 0,
        second: 0,
        std_offset: 0, time_zone: "Etc/UTC", utc_offset: 0,zone_abbr: "UTC"
      }
    end

    Time <- :integer + ":" + :integer = fn [h, _, m] -> {h, m} end

    Month <- "Jan" = fn _ -> 1 end
    Month <- "Feb" = fn _ -> 2 end
    Month <- "Mar" = fn _ -> 3 end
    Month <- "Apr" = fn _ -> 4 end
    Month <- "May" = fn _ -> 5 end
    Month <- "Jun" = fn _ -> 6 end
    Month <- "Jul" = fn _ -> 7 end
    Month <- "Aug" = fn _ -> 8 end
    Month <- "Sep" = fn _ -> 9 end
    Month <- "Oct" = fn _ -> 10 end
    Month <- "Nov" = fn _ -> 11 end
    Month <- "Dez" = fn _ -> 12 end
  end

end
