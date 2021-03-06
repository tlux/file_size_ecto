defmodule FileSize.Ecto.ByteTest do
  use ExUnit.Case

  import FileSize.Sigil

  alias FileSize.Ecto.Byte

  describe "type/0" do
    test "is integer" do
      assert Byte.type() == :integer
    end
  end

  describe "embed_as/1" do
    test "is :self" do
      assert Byte.embed_as(nil) == :self
    end
  end

  describe "cast/1" do
    test "cast FileSize.Byte" do
      assert Byte.cast(~F(4 B)) == {:ok, ~F(4 B)}
      assert Byte.cast(~F(4 kB)) == {:ok, ~F(4000 B)}
      assert Byte.cast(~F(4 KiB)) == {:ok, ~F(4096 B)}
    end

    test "cast map with atom keys" do
      assert Byte.cast(%{value: 16, unit: :kb}) == {:ok, ~F(16000 B)}
      assert Byte.cast(%{value: 16.0, unit: :kb}) == {:ok, ~F(16000 B)}

      assert Byte.cast(%{value: Decimal.new(16), unit: :kb}) ==
               {:ok, ~F(16000 B)}

      assert Byte.cast(%{bytes: 16_000, unit: :kb}) == {:ok, ~F(16000 B)}
    end

    test "cast map with string keys" do
      assert Byte.cast(%{"value" => 16, "unit" => "kb"}) == {:ok, ~F(16000 B)}
      assert Byte.cast(%{"value" => 16.0, "unit" => "kb"}) == {:ok, ~F(16000 B)}

      assert Byte.cast(%{"value" => Decimal.new(16), "unit" => "kb"}) ==
               {:ok, ~F(16000 B)}

      assert Byte.cast(%{"bytes" => 16_000, "unit" => "kb"}) ==
               {:ok, ~F(16000 B)}
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

  describe "equal?/2" do
    test "equality" do
      assert Byte.equal?(nil, nil) == true
      assert Byte.equal?(~F(16 B), ~F(16 B)) == true
      assert Byte.equal?(~F(16 kB), ~F(16000 B)) == true
    end

    test "inequality" do
      assert Byte.equal?(~F(16 B), nil) == false
      assert Byte.equal?(nil, ~F(16 B)) == false
      assert Byte.equal?(~F(17 B), ~F(16 B)) == false
      assert Byte.equal?(~F(17 kB), ~F(16000 B)) == false
      assert Byte.equal?(:invalid, :invalid) == false
    end
  end
end
