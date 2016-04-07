defmodule Happi.Transform do
  
  @moduledoc """
  Functions that help with conversion between JSON and our structs.
  """

  @datetime_regex ~r{^(\d\d\d\d)-(\d\d)-(\d\d)T(\d\d):(\d\d):(\d\d)Z$}
  @datetime_format "~4..0B-~2..0B-~2..0BT~2..0B:~2..0B:~2..0BZ"

  alias Happi.Heroku.Error

  @doc """
  Given either an API response JSON string or an `Error`, either parses the
  JSON as `decode_type` and returns that struct or returns the `Error`
  struct.

  Converts datetime strings into Erlang `date()` tuples.
  """
  @spec decode!(String.t | Error.t, module | Enum.t) :: map
  def decode!(%Error{} = err, _) do
    err
  end
  def decode!(body, decode_type) do
    body |> Poison.decode!(as: decode_type) |> datetime_strings_to_timestamps
  end

  @doc """
  Given a `Happi.Heroku.*` struct, return JSON.

  Converts Erlang `date()` tuples into strings.
  """
  @spec encode!(map) :: String.t
  def encode!(data) do
    data |> timestamps_to_datetime_strings |> Poison.encode!
  end

  # ================ Private helpers ================

  defp datetime_strings_to_timestamps(data) when is_list(data) do
    data |> Enum.map(&(datetime_strings_to_timestamps(&1)))
  end
  defp datetime_strings_to_timestamps(data) do
    timestamps = datetime_keys(data)
    |> Enum.map(&({&1, Map.get(data, &1)}))
    |> Enum.filter(fn({_, v}) -> v end)
    |> Enum.map(fn({k, v}) ->
      matches = Regex.run(@datetime_regex, v)
      if matches do
        [_ | ts_strs] = matches
        [y, m, d, h, n, s] = ts_strs |> Enum.map(&String.to_integer/1)
        ts = {{y, m, d}, {h, n, s}}
        {k, ts}
      else
        {k, v}
      end
    end)
    |> Enum.into(%{})
    Map.merge(data, timestamps)
  end

  defp timestamps_to_datetime_strings(data) when is_list(data) do
    data |> Enum.map(&(timestamps_to_datetime_strings(&1)))
  end
  defp timestamps_to_datetime_strings(data) do
    dt_strings = datetime_keys(data)
    |> Enum.map(fn(k) ->        # convert to string, return {key, string}
      val = Map.get(data, k)
      case val do
        {{y, m, d}, {h, n, s}} ->
          s = :io_lib.format(@datetime_format, [y, m, d, h, n, s])
          |> IO.iodata_to_binary
          {k, s}
        _ ->
          {k, val}
      end
    end)
    |> Enum.into(%{})
    Map.merge(data, dt_strings)
  end

  defp datetime_keys(data) do
    Map.keys(data) |> Enum.filter(fn(k) ->
      s = to_string(k)
      String.length(s) > 3 && String.slice(s, -3, 3) == "_at"
    end)
  end
end
