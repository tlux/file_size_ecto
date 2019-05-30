defmodule FileSizeEcto.ChangesetIntegrationTest do
  use ExUnit.Case

  import Ecto.Changeset

  describe "Ecto.Changeset.cast/2" do
    test "valid when value present" do
      changeset = cast(%TestSchema{}, %{byte_size: "16 MB"}, [:byte_size])

      assert Enum.empty?(changeset.errors)
      assert get_change(changeset, :byte_size) == FileSize.new(16_000_000, :b)
    end

    test "valid when value blank" do
      changeset = cast(%TestSchema{}, %{byte_size: ""}, [:byte_size])

      assert Enum.empty?(changeset.errors)
      assert get_change(changeset, :byte_size) == nil
    end

    test "invalid format" do
      changeset = cast(%TestSchema{}, %{byte_size: "invalid"}, [:byte_size])

      assert changeset.errors != []
    end
  end
end
