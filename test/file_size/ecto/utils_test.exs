defmodule FileSize.Ecto.UtilsTest do
  use ExUnit.Case

  alias FileSize.Bit
  alias FileSize.Byte
  alias FileSize.Ecto.Utils

  describe "assert_value/1" do
    test "success with Decimal" do
      value = Decimal.new(16)

      assert Utils.assert_value(value) == {:ok, value}
    end

    test "success with float" do
      value = 16.4

      assert Utils.assert_value(value) == {:ok, value}
    end

    test "success with integer" do
      value = 16

      assert Utils.assert_value(value) == {:ok, value}
    end

    test "error" do
      assert Utils.assert_value("16") == :error
      assert Utils.assert_value(:invalid) == :error
    end
  end

  describe "parse_unit_for_type/2" do
    test "success with atom arg" do
      assert Utils.parse_unit_for_type(:mb, Byte) == {:ok, :mb}
      assert Utils.parse_unit_for_type(:mib, Byte) == {:ok, :mib}
      assert Utils.parse_unit_for_type(:kbit, Bit) == {:ok, :kbit}
    end

    test "success with string arg" do
      assert Utils.parse_unit_for_type("mb", Byte) == {:ok, :mb}
      assert Utils.parse_unit_for_type("mib", Byte) == {:ok, :mib}
      assert Utils.parse_unit_for_type("kbit", Bit) == {:ok, :kbit}
    end

    test "error" do
      assert Utils.parse_unit_for_type("kb", Bit) == :error
      assert Utils.parse_unit_for_type(:kb, Bit) == :error
      assert Utils.parse_unit_for_type("kbit", Byte) == :error
      assert Utils.parse_unit_for_type(:kbit, Byte) == :error
      assert Utils.parse_unit_for_type(:unknown, Bit) == :error
      assert Utils.parse_unit_for_type(:unknown, Byte) == :error
    end
  end

  describe "serialize_unit/1" do
    test "serialize atom" do
      assert Utils.serialize_unit(:mb) == "mb"
      assert Utils.serialize_unit(:mib) == "mib"
      assert Utils.serialize_unit(:kbit) == "kbit"
    end

    test "serialize string" do
      assert Utils.serialize_unit("mb") == "mb"
      assert Utils.serialize_unit("mib") == "mib"
      assert Utils.serialize_unit("kbit") == "kbit"
    end
  end
end
