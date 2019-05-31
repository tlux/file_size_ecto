defmodule FileSizeEcto.UtilsTest do
  use ExUnit.Case

  alias FileSize.UnitInfo
  alias FileSizeEcto.Utils

  describe "parse_unit/1" do
    test "success with atom arg" do
      assert {:ok, %UnitInfo{name: :mb}} = Utils.parse_unit(:mb)
      assert {:ok, %UnitInfo{name: :mib}} = Utils.parse_unit(:mib)
      assert {:ok, %UnitInfo{name: :kbit}} = Utils.parse_unit(:kbit)
    end

    test "success with string arg" do
      assert {:ok, %UnitInfo{name: :mb}} = Utils.parse_unit("mb")
      assert {:ok, %UnitInfo{name: :mib}} = Utils.parse_unit("mib")
      assert {:ok, %UnitInfo{name: :kbit}} = Utils.parse_unit("kbit")
    end

    test "error" do
      assert Utils.parse_unit(:unknown) == :error
    end
  end
end
