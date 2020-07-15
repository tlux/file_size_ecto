defmodule FileSize.Ecto.BitWithUnitTest do
  use ExUnit.Case

  import FileSize.Sigil

  alias FileSize.Ecto.BitWithUnit

  describe "type/0" do
    test "is map" do
      assert BitWithUnit.type() == :map
    end
  end

  describe "embed_as/1" do
    test "is :self" do
      assert BitWithUnit.embed_as(nil) == :dump
    end
  end

  describe "cast/1" do
    test "cast FileSize.Bit" do
      Enum.each([~F(4 bit), ~F(4 kbit), ~F(4 Kibit)], fn size ->
        assert BitWithUnit.cast(size) == {:ok, size}
      end)
    end

    test "cast map with atom keys" do
      assert BitWithUnit.cast(%{value: 16, unit: :gbit}) == {:ok, ~F(16 Gbit)}

      assert BitWithUnit.cast(%{value: 16.0, unit: :gbit}) == {:ok, ~F(16 Gbit)}

      assert BitWithUnit.cast(%{value: Decimal.new(16), unit: :gbit}) ==
               {:ok, ~F(16 Gbit)}

      assert BitWithUnit.cast(%{bits: 16_000, unit: :kbit}) ==
               {:ok, ~F(16 kbit)}
    end

    test "cast map with string keys" do
      assert BitWithUnit.cast(%{"value" => 16, "unit" => "gbit"}) ==
               {:ok, ~F(16 Gbit)}

      assert BitWithUnit.cast(%{"value" => 16.0, "unit" => "gbit"}) ==
               {:ok, ~F(16 Gbit)}

      assert BitWithUnit.cast(%{"value" => Decimal.new(16), "unit" => "gbit"}) ==
               {:ok, ~F(16 Gbit)}

      assert BitWithUnit.cast(%{"bits" => 16_000, "unit" => "kbit"}) ==
               {:ok, ~F(16 kbit)}
    end

    test "cast integer" do
      assert BitWithUnit.cast(12) == {:ok, ~F(12 bit)}
      assert BitWithUnit.cast(1234) == {:ok, ~F(1234 bit)}
    end

    test "cast float" do
      assert BitWithUnit.cast(12.34) == {:ok, ~F(12 bit)}
    end

    test "cast string" do
      Enum.each(["16 Gbit", "8 Gibit", "12 bit"], fn str ->
        assert BitWithUnit.cast(str) == FileSize.parse(str)
      end)
    end

    test "error" do
      assert BitWithUnit.cast("") == :error
      assert BitWithUnit.cast("16 in") == :error
      assert BitWithUnit.cast(:invalid) == :error
      assert BitWithUnit.cast("16 B") == :error
      assert BitWithUnit.cast("16 kB") == :error
      assert BitWithUnit.cast("16 KiB") == :error
      assert BitWithUnit.cast(~F(16 B)) == :error
      assert BitWithUnit.cast(~F(16 kB)) == :error
      assert BitWithUnit.cast(~F(16 KiB)) == :error
      assert BitWithUnit.cast(%{value: nil, unit: nil}) == :error
      assert BitWithUnit.cast(%{value: "", unit: ""}) == :error
      assert BitWithUnit.cast(%{value: "1", unit: :kb}) == :error
      assert BitWithUnit.cast(%{value: 1, unit: ""}) == :error
      assert BitWithUnit.cast(%{"value" => nil, "unit" => nil}) == :error
      assert BitWithUnit.cast(%{"value" => "", "unit" => ""}) == :error
      assert BitWithUnit.cast(%{"value" => "1", "unit" => "kib"}) == :error
      assert BitWithUnit.cast(%{"value" => 1, "unit" => ""}) == :error
      assert BitWithUnit.cast(%{}) == :error
    end
  end

  describe "dump/1" do
    test "dump FileSize.Bit" do
      assert BitWithUnit.dump(~F(16 Mbit)) ==
               {:ok, %{"bits" => 16_000_000, "unit" => "mbit"}}

      assert BitWithUnit.dump(~F(16 Mibit)) ==
               {:ok, %{"bits" => 16_777_216, "unit" => "mibit"}}
    end

    test "error" do
      assert BitWithUnit.dump(1234) == :error
      assert BitWithUnit.dump(12.34) == :error
      assert BitWithUnit.dump("") == :error
      assert BitWithUnit.dump("16 in") == :error
      assert BitWithUnit.dump(:invalid) == :error
      assert BitWithUnit.dump("16 B") == :error
      assert BitWithUnit.dump("16 kB") == :error
      assert BitWithUnit.dump("16 KiB") == :error
      assert BitWithUnit.dump(~F(16 B)) == :error
      assert BitWithUnit.dump(~F(16 kB)) == :error
      assert BitWithUnit.dump(~F(16 KiB)) == :error
      assert BitWithUnit.cast(%{}) == :error
    end
  end

  describe "load/1" do
    test "load map" do
      assert BitWithUnit.load(%{"bits" => 1_000_000, "unit" => "kbit"}) ==
               {:ok, ~F(1000 kbit)}

      assert BitWithUnit.load(%{"bits" => 1_000_000, "unit" => "kibit"}) ==
               {:ok, ~F(976.5625 Kibit)}
    end

    test "error" do
      assert BitWithUnit.load(1234) == :error
      assert BitWithUnit.load(12.34) == :error
      assert BitWithUnit.load("") == :error
      assert BitWithUnit.load("16 in") == :error
      assert BitWithUnit.load(:invalid) == :error
      assert BitWithUnit.load("16 B") == :error
      assert BitWithUnit.load("16 kB") == :error
      assert BitWithUnit.load("16 KiB") == :error
      assert BitWithUnit.load(~F(16 B)) == :error
      assert BitWithUnit.load(~F(16 kB)) == :error
      assert BitWithUnit.load(~F(16 KiB)) == :error

      assert BitWithUnit.load(%{"bits" => 1_000_000, "unit" => "kb"}) ==
               :error

      assert BitWithUnit.load(%{"bytes" => 1234, "unit" => "kbit"}) ==
               :error
    end
  end

  describe "equal?/2" do
    test "equality" do
      assert BitWithUnit.equal?(nil, nil) == true
      assert BitWithUnit.equal?(~F(16 B), ~F(16 B)) == true
      assert BitWithUnit.equal?(~F(16 kB), ~F(16000 B)) == true
    end

    test "inequality" do
      assert BitWithUnit.equal?(~F(16 B), nil) == false
      assert BitWithUnit.equal?(nil, ~F(16 B)) == false
      assert BitWithUnit.equal?(~F(17 B), ~F(16 B)) == false
      assert BitWithUnit.equal?(~F(17 kB), ~F(16000 B)) == false
      assert BitWithUnit.equal?(:invalid, :invalid) == false
    end
  end
end
