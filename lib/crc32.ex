defmodule Crc32 do
  @moduledoc """
  Documentation for `Crc32`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Crc32.hello()
      :world

  """
  require Logger

  @crc32_length 4

  @spec encode(bitstring()) ::
          {:ok, {bitstring(), integer()}} | {:error, binary()}
  def encode(raw) when is_bitstring(raw) do
    case Crc32.check_value(raw) do
      {:ok, crc} ->
        {:ok, {raw <> <<crc::32>>, crc}}

      {:error, error} ->
        Logger.error("Unable to encode data: #{error}")
        {:error, error}
    end
  end

  @spec decode(bitstring(), integer()) ::
          {:ok, {bitstring(), integer()}} | {:error, {bitstring(), integer()}}
  def decode(encoded_raw, check_value)
      when is_bitstring(encoded_raw) and is_integer(check_value) do
    if Crc32.valid?(encoded_raw, check_value) do
      data_length = IO.iodata_length(encoded_raw) - @crc32_length
      <<raw::binary-size(data_length), crc_value::32>> = encoded_raw
      {:ok, {raw, crc_value}}
    else
      {:error, {encoded_raw, check_value}}
    end
  end

  @spec valid?(bitstring(), integer()) :: boolean()
  def valid?(encoded_raw, check_value)
      when is_bitstring(encoded_raw) and is_integer(check_value) do
    data_length = IO.iodata_length(encoded_raw) - @crc32_length
    <<_raw::binary-size(data_length), crc_value::32>> = encoded_raw
    check_value == crc_value
  end

  @spec check_value(bitstring()) ::
          {:ok, integer()} | {:error, binary()}
  def check_value(raw) when is_bitstring(raw) do
    try do
      {:ok, :erlang.crc32(raw)}
    rescue
      error in ArgumentError ->
        {:error, error.message}
    end
  end
end
