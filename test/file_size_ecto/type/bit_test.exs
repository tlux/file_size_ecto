defmodule FileSizeEcto.Type.BitTest do
  use ExUnit.Case

  import FileSize.Sigil

  alias FileSizeEcto.Type.Bit

  describe "type/0" do
    test "is integer" do
      assert Bit.type() == :integer
    end
  end

  describe "cast/1" do
    test "cast string" do
      Enum.each(["16 Gbit", "8 Gibit", "12 B", "16 GB"], fn str ->
        size =
          str
          |> FileSize.parse!()
          |> FileSize.convert(:bit)

        assert Bit.cast(str) == {:ok, size}
      end)
    end

    test "cast integer" do
      bits = 1_234_567

      assert Bit.cast(bits) == {:ok, FileSize.new(bits, :bit)}
    end

    test "cast float" do
      assert Bit.cast(12345.67) == {:ok, ~F(12345 bit)}
    end

    test "case FileSize.Bit" do
      assert Bit.cast(~F(4 bit)) == {:ok, ~F(4 bit)}
      assert Bit.cast(~F(4 kbit)) == {:ok, ~F(4000 bit)}
      assert Bit.cast(~F(4 Kibit)) == {:ok, ~F(4096 bit)}
    end

    test "cast FileSize.Byte" do
      assert Bit.cast(~F(4 B)) == {:ok, ~F(32 bit)}
      assert Bit.cast(~F(4 kB)) == {:ok, ~F(32000 bit)}
      assert Bit.cast(~F(4 KiB)) == {:ok, ~F(32768 bit)}
    end

    test "error" do
      assert Bit.cast("") == :error
      assert Bit.cast("16 in") == :error
      assert Bit.cast(:invalid) == :error
    end
  end

  describe "dump/1" do
    test "dump string" do
      Enum.each(["16 Gbit", "8 Gibit", "12 B", "16 GB"], fn str ->
        bit =
          str
          |> FileSize.parse!()
          |> FileSize.convert(:bit)
          |> Map.fetch!(:bits)

        assert Bit.dump(str) == {:ok, bit}
      end)
    end

    test "dump integer" do
      value = 1_234_567

      assert Bit.dump(value) == {:ok, value}
    end

    test "dump float" do
      assert Bit.dump(12345.67) == {:ok, 12345}
    end

    test "dump FileSize.Bit" do
      assert Bit.dump(~F(4 bit)) == {:ok, 4}
      assert Bit.dump(~F(4 kbit)) == {:ok, 4000}
      assert Bit.dump(~F(4 Kibit)) == {:ok, 4096}
    end

    test "dump FileSize.Byte" do
      assert Bit.dump(~F(4 B)) == {:ok, 32}
      assert Bit.dump(~F(4 kB)) == {:ok, 32000}
      assert Bit.dump(~F(4 KiB)) == {:ok, 32768}
    end

    test "error" do
      assert Bit.dump("") == :error
      assert Bit.dump("16 in") == :error
      assert Bit.dump(:invalid) == :error
    end
  end

  describe "load/1" do
    test "load integer" do
      bits = 1_234_567

      assert Bit.load(bits) == {:ok, FileSize.new(bits, :bit)}
    end

    test "error" do
      assert Bit.load("1234567") == :error
    end
  end
end
