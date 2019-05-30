defmodule FileSizeEcto.ByteTest do
  use ExUnit.Case

  import FileSize.Sigil

  alias FileSizeEcto.Byte

  describe "type/0" do
    test "is integer" do
      assert Byte.type() == :integer
    end
  end

  describe "cast/1" do
    test "cast string" do
      Enum.each(["16 GB", "8 GiB", "12 B", "16 bit"], fn str ->
        size =
          str
          |> FileSize.parse!()
          |> FileSize.convert(:b)

        assert Byte.cast(str) == {:ok, size}
      end)
    end

    test "cast integer" do
      bytes = 1_234_567

      assert Byte.cast(bytes) == {:ok, FileSize.new(bytes, :b)}
    end

    test "cast float" do
      assert Byte.cast(12345.67) == {:ok, ~F(12345 B)}
    end

    test "cast FileSize.Byte" do
      assert Byte.cast(~F(4 B)) == {:ok, ~F(4 B)}
      assert Byte.cast(~F(4 kB)) == {:ok, ~F(4000 B)}
      assert Byte.cast(~F(4 KiB)) == {:ok, ~F(4096 B)}
    end

    test "cast FileSize.Bit" do
      assert Byte.cast(~F(16 bit)) == {:ok, ~F(2 B)}
      assert Byte.cast(~F(16 kbit)) == {:ok, ~F(2000 B)}
      assert Byte.cast(~F(16 Kibit)) == {:ok, ~F(2048 B)}
    end

    test "error" do
      assert Byte.cast("") == :error
      assert Byte.cast("16 in") == :error
      assert Byte.cast(:invalid) == :error
    end
  end

  describe "dump/1" do
    test "dump string" do
      Enum.each(["16 GB", "8 GiB", "12 B", "16 bit"], fn str ->
        bytes =
          str
          |> FileSize.parse!()
          |> FileSize.convert(:b)
          |> Map.fetch!(:bytes)

        assert Byte.dump(str) == {:ok, bytes}
      end)
    end

    test "dump integer" do
      value = 1_234_567

      assert Byte.dump(value) == {:ok, value}
    end

    test "dump float" do
      assert Byte.dump(12345.67) == {:ok, 12345}
    end

    test "dump FileSize.Byte" do
      assert Byte.dump(~F(4 B)) == {:ok, 4}
      assert Byte.dump(~F(4 kB)) == {:ok, 4000}
      assert Byte.dump(~F(4 KiB)) == {:ok, 4096}
    end

    test "dump FileSize.Bit" do
      assert Byte.dump(~F(16 bit)) == {:ok, 2}
      assert Byte.dump(~F(16 kbit)) == {:ok, 2000}
      assert Byte.dump(~F(16 Kibit)) == {:ok, 2048}
    end

    test "error" do
      assert Byte.dump("") == :error
      assert Byte.dump("16 in") == :error
      assert Byte.dump(:invalid) == :error
    end
  end

  describe "load/1" do
    test "load integer" do
      bytes = 1_234_567

      assert Byte.load(bytes) == {:ok, FileSize.new(bytes, :b)}
    end

    test "error" do
      assert Byte.load("1234567") == :error
    end
  end
end
