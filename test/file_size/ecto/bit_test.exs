defmodule FileSize.Ecto.BitTest do
  use ExUnit.Case

  import FileSize.Sigil

  alias FileSize.Ecto.Bit

  describe "type/0" do
    test "is integer" do
      assert Bit.type() == :integer
    end
  end

  describe "cast/1" do
    test "cast FileSize.Bit" do
      assert Bit.cast(~F(4 bit)) == {:ok, ~F(4 bit)}
      assert Bit.cast(~F(4 kbit)) == {:ok, ~F(4000 bit)}
      assert Bit.cast(~F(4 Kibit)) == {:ok, ~F(4096 bit)}
    end

    test "cast map with atom keys" do
      assert Bit.cast(%{value: 16, unit: :kbit}) == {:ok, ~F(16000 bit)}
      assert Bit.cast(%{value: 16.0, unit: :kbit}) == {:ok, ~F(16000 bit)}

      assert Bit.cast(%{value: Decimal.new(16), unit: :kbit}) ==
               {:ok, ~F(16000 bit)}

      assert Bit.cast(%{bits: 16_000, unit: :kbit}) == {:ok, ~F(16000 bit)}
    end

    test "cast map with string keys" do
      assert Bit.cast(%{"value" => 16, "unit" => "kbit"}) ==
               {:ok, ~F(16000 bit)}

      assert Bit.cast(%{"value" => 16.0, "unit" => "kbit"}) ==
               {:ok, ~F(16000 bit)}

      assert Bit.cast(%{"value" => Decimal.new(16), "unit" => "kbit"}) ==
               {:ok, ~F(16000 bit)}

      assert Bit.cast(%{"bits" => 16_000, "unit" => "kbit"}) ==
               {:ok, ~F(16000 bit)}
    end

    test "cast integer" do
      assert Bit.cast(12) == {:ok, ~F(12 bit)}
    end

    test "cast float" do
      assert Bit.cast(12.34) == {:ok, ~F(12 bit)}
    end

    test "cast string" do
      Enum.each(["16 Gbit", "8 Gibit", "12 bit"], fn str ->
        size =
          str
          |> FileSize.parse!()
          |> FileSize.convert(:bit)

        assert Bit.cast(str) == {:ok, size}
      end)
    end

    test "error" do
      assert Bit.cast("") == :error
      assert Bit.cast("16 in") == :error
      assert Bit.cast(:invalid) == :error
      assert Bit.cast("16 B") == :error
      assert Bit.cast("16 kB") == :error
      assert Bit.cast("16 KiB") == :error
      assert Bit.cast(~F(16 B)) == :error
      assert Bit.cast(~F(16 kB)) == :error
      assert Bit.cast(~F(16 KiB)) == :error
    end
  end

  describe "dump/1" do
    test "dump FileSize.Bit" do
      assert Bit.dump(~F(4 bit)) == {:ok, 4}
      assert Bit.dump(~F(4 kbit)) == {:ok, 4000}
      assert Bit.dump(~F(4 Kibit)) == {:ok, 4096}
    end

    test "error" do
      assert Bit.dump(1234) == :error
      assert Bit.dump(12.34) == :error
      assert Bit.dump("") == :error
      assert Bit.dump("16 in") == :error
      assert Bit.dump(:invalid) == :error
      assert Bit.dump("16 B") == :error
      assert Bit.dump("16 kB") == :error
      assert Bit.dump("16 KiB") == :error
      assert Bit.dump(~F(16 B)) == :error
      assert Bit.dump(~F(16 kB)) == :error
      assert Bit.dump(~F(16 KiB)) == :error
    end
  end

  describe "load/1" do
    test "load integer" do
      assert Bit.load(1234) == {:ok, ~F(1234 bit)}
    end

    test "error" do
      assert Bit.load(12.34) == :error
      assert Bit.load("") == :error
      assert Bit.load("16 in") == :error
      assert Bit.load(:invalid) == :error
      assert Bit.load("16 B") == :error
      assert Bit.load("16 kB") == :error
      assert Bit.load("16 KiB") == :error
      assert Bit.load(~F(16 B)) == :error
      assert Bit.load(~F(16 kB)) == :error
      assert Bit.load(~F(16 KiB)) == :error
    end
  end
end
