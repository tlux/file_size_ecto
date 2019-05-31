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
    test "cast FileSize.Byte" do
      assert Byte.cast(~F(4 B)) == {:ok, ~F(4 B)}
      assert Byte.cast(~F(4 kB)) == {:ok, ~F(4000 B)}
      assert Byte.cast(~F(4 KiB)) == {:ok, ~F(4096 B)}
    end

    test "cast integer" do
      assert Byte.cast(12) == {:ok, ~F(12 B)}
    end

    test "cast float" do
      assert Byte.cast(12.34) == {:ok, ~F(12 B)}
    end

    test "cast string" do
      Enum.each(["16 GB", "8 GiB", "12 B"], fn str ->
        size =
          str
          |> FileSize.parse!()
          |> FileSize.convert(:b)

        assert Byte.cast(str) == {:ok, size}
      end)
    end

    test "error" do
      assert Byte.cast("") == :error
      assert Byte.cast("16 in") == :error
      assert Byte.cast(:invalid) == :error
      assert Byte.cast("16 bit") == :error
      assert Byte.cast("16 kbit") == :error
      assert Byte.cast("16 Kibit") == :error
      assert Byte.cast(~F(16 bit)) == :error
      assert Byte.cast(~F(16 kbit)) == :error
      assert Byte.cast(~F(16 Kibit)) == :error
    end
  end

  describe "dump/1" do
    test "dump FileSize.Byte" do
      assert Byte.dump(~F(4 B)) == {:ok, 4}
      assert Byte.dump(~F(4 kB)) == {:ok, 4000}
      assert Byte.dump(~F(4 KiB)) == {:ok, 4096}
    end

    test "error" do
      assert Byte.dump(1234) == :error
      assert Byte.dump(12.34) == :error
      assert Byte.dump("") == :error
      assert Byte.dump("16 in") == :error
      assert Byte.dump(:invalid) == :error
      assert Byte.dump("16 bit") == :error
      assert Byte.dump("16 kbit") == :error
      assert Byte.dump("16 Kibit") == :error
      assert Byte.dump(~F(16 bit)) == :error
      assert Byte.dump(~F(16 kbit)) == :error
      assert Byte.dump(~F(16 Kibit)) == :error
    end
  end

  describe "load/1" do
    test "load integer" do
      assert Byte.load(1234) == {:ok, ~F(1234 B)}
    end

    test "error" do
      assert Byte.load(12.34) == :error
      assert Byte.load("") == :error
      assert Byte.load("16 in") == :error
      assert Byte.load(:invalid) == :error
      assert Byte.load("16 bit") == :error
      assert Byte.load("16 kbit") == :error
      assert Byte.load("16 Kibit") == :error
      assert Byte.load(~F(16 bit)) == :error
      assert Byte.load(~F(16 kbit)) == :error
      assert Byte.load(~F(16 Kibit)) == :error
    end
  end
end
