defmodule FileSize.Ecto.ByteWithUnitTest do
  use ExUnit.Case

  import FileSize.Sigil

  alias FileSize.Ecto.ByteWithUnit

  describe "type/0" do
    test "is map" do
      assert ByteWithUnit.type() == :map
    end
  end

  describe "embed_as/1" do
    test "is :self" do
      assert ByteWithUnit.embed_as(nil) == :dump
    end
  end

  describe "cast/1" do
    test "cast FileSize.Byte" do
      Enum.each([~F(4 B), ~F(4 kB), ~F(4 KiB)], fn size ->
        assert ByteWithUnit.cast(size) == {:ok, size}
      end)
    end

    test "cast map with atom keys" do
      assert ByteWithUnit.cast(%{value: 16, unit: :gb}) == {:ok, ~F(16 GB)}
      assert ByteWithUnit.cast(%{value: 16.0, unit: :gb}) == {:ok, ~F(16 GB)}

      assert ByteWithUnit.cast(%{value: Decimal.new(16), unit: :gb}) ==
               {:ok, ~F(16 GB)}

      assert ByteWithUnit.cast(%{bytes: 16_000, unit: :kb}) == {:ok, ~F(16 kB)}
    end

    test "cast map with string keys" do
      assert ByteWithUnit.cast(%{"value" => 16, "unit" => "gb"}) ==
               {:ok, ~F(16 GB)}

      assert ByteWithUnit.cast(%{"value" => 16.0, "unit" => "gb"}) ==
               {:ok, ~F(16 GB)}

      assert ByteWithUnit.cast(%{"value" => Decimal.new(16), "unit" => "gb"}) ==
               {:ok, ~F(16 GB)}

      assert ByteWithUnit.cast(%{"bytes" => 16_000, "unit" => "kb"}) ==
               {:ok, ~F(16 kB)}
    end

    test "cast integer" do
      assert ByteWithUnit.cast(12) == {:ok, ~F(12 B)}
      assert ByteWithUnit.cast(1234) == {:ok, ~F(1234 B)}
    end

    test "cast float" do
      assert ByteWithUnit.cast(12.34) == {:ok, ~F(12 B)}
    end

    test "cast string" do
      Enum.each(["16 GB", "8 GiB", "12 B"], fn str ->
        assert ByteWithUnit.cast(str) == FileSize.parse(str)
      end)
    end

    test "error" do
      assert ByteWithUnit.cast("") == :error
      assert ByteWithUnit.cast("16 in") == :error
      assert ByteWithUnit.cast(:invalid) == :error
      assert ByteWithUnit.cast("16 bit") == :error
      assert ByteWithUnit.cast("16 kbit") == :error
      assert ByteWithUnit.cast("16 Kibit") == :error
      assert ByteWithUnit.cast(~F(16 bit)) == :error
      assert ByteWithUnit.cast(~F(16 kbit)) == :error
      assert ByteWithUnit.cast(~F(16 Kibit)) == :error
      assert ByteWithUnit.cast(%{value: nil, unit: nil}) == :error
      assert ByteWithUnit.cast(%{value: "", unit: ""}) == :error
      assert ByteWithUnit.cast(%{value: "1", unit: :kb}) == :error
      assert ByteWithUnit.cast(%{value: 1, unit: ""}) == :error
      assert ByteWithUnit.cast(%{"value" => nil, "unit" => nil}) == :error
      assert ByteWithUnit.cast(%{"value" => "", "unit" => ""}) == :error
      assert ByteWithUnit.cast(%{"value" => "1", "unit" => "kb"}) == :error
      assert ByteWithUnit.cast(%{"value" => 1, "unit" => ""}) == :error
      assert ByteWithUnit.cast(%{}) == :error
    end
  end

  describe "dump/1" do
    test "dump FileSize.Byte" do
      assert ByteWithUnit.dump(~F(16 MB)) ==
               {:ok, %{"bytes" => 16_000_000, "unit" => "mb"}}

      assert ByteWithUnit.dump(~F(16 MiB)) ==
               {:ok, %{"bytes" => 16_777_216, "unit" => "mib"}}
    end

    test "error" do
      assert ByteWithUnit.dump(1234) == :error
      assert ByteWithUnit.dump(12.34) == :error
      assert ByteWithUnit.dump("") == :error
      assert ByteWithUnit.dump("16 in") == :error
      assert ByteWithUnit.dump(:invalid) == :error
      assert ByteWithUnit.dump("16 bit") == :error
      assert ByteWithUnit.dump("16 kbit") == :error
      assert ByteWithUnit.dump("16 Kibit") == :error
      assert ByteWithUnit.dump(~F(16 bit)) == :error
      assert ByteWithUnit.dump(~F(16 kbit)) == :error
      assert ByteWithUnit.dump(~F(16 Kibit)) == :error
      assert ByteWithUnit.cast(%{}) == :error
    end
  end

  describe "load/1" do
    test "load map" do
      assert ByteWithUnit.load(%{"bytes" => 1_000_000, "unit" => "kb"}) ==
               {:ok, ~F(1000 kB)}

      assert ByteWithUnit.load(%{"bytes" => 1_000_000, "unit" => "kib"}) ==
               {:ok, ~F(976.5625 KiB)}
    end

    test "error" do
      assert ByteWithUnit.load(1234) == :error
      assert ByteWithUnit.load(12.34) == :error
      assert ByteWithUnit.load("") == :error
      assert ByteWithUnit.load("16 in") == :error
      assert ByteWithUnit.load(:invalid) == :error
      assert ByteWithUnit.load("16 bit") == :error
      assert ByteWithUnit.load("16 kbit") == :error
      assert ByteWithUnit.load("16 Kibit") == :error
      assert ByteWithUnit.load(~F(16 bit)) == :error
      assert ByteWithUnit.load(~F(16 kbit)) == :error
      assert ByteWithUnit.load(~F(16 Kibit)) == :error

      assert ByteWithUnit.load(%{"bytes" => 1_000_000, "unit" => "kbit"}) ==
               :error

      assert ByteWithUnit.load(%{"bits" => 1234, "unit" => "kb"}) ==
               :error
    end
  end
end
