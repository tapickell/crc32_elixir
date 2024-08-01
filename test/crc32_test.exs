defmodule Crc32Test do
  use ExUnit.Case
  doctest Crc32

  test "encodes a raw bistring" do
    raw =
      <<1, 2, 3, 4, 99, 88, 77, 11, 0, 0, 1, 188, 98, 87, 76, 65, 131, 104, 18, 104, 2, 100, 0, 2,
        105, 100, 90, 0, 3, 100, 0, 13, 110, 111, 110, 111, 100, 101, 64, 110, 111, 104, 111, 115,
        116, 0, 0, 0, 0, 0>>

    assert Crc32.encode(raw) == :world
  end

  test "decodes an encoded bitstring" do
    raw =
      <<1, 2, 3, 4, 99, 88, 77, 11, 0, 0, 1, 188, 98, 87, 76, 65, 131, 104, 18, 104, 2, 100, 0, 2,
        105, 100, 90, 0, 3, 100, 0, 13, 110, 111, 110, 111, 100, 101, 64, 110, 111, 104, 111, 115,
        116, 0, 0, 0, 0, 0>>

    encoded = Crc32.encode(raw)

    assert Crc32.decode(encoded) == :world
  end

  test "validates and encoded bit string" do
    raw =
      <<1, 2, 3, 4, 99, 88, 77, 11, 0, 0, 1, 188, 98, 87, 76, 65, 131, 104, 18, 104, 2, 100, 0, 2,
        105, 100, 90, 0, 3, 100, 0, 13, 110, 111, 110, 111, 100, 101, 64, 110, 111, 104, 111, 115,
        116, 0, 0, 0, 0, 0>>

    crc = Crc32.check_value(raw)
    encoded = Crc32.encode(raw)

    assert Crc32.valid?(encoded, crc)
  end
end
