defmodule FileSize.Ecto.ChangesetIntegrationTest do
  use ExUnit.Case

  import Ecto.Changeset

  describe "Ecto.Changeset.cast/2 with FileSize.Ecto.Bit" do
    test "valid when value present" do
      changeset = cast(%TestSchema{}, %{bit_size: "16 Mbit"}, [:bit_size])

      assert errors_on(changeset, :bit_size) == []
      assert get_change(changeset, :bit_size) == FileSize.new(16_000_000, :bit)
    end

    test "valid when value blank" do
      changeset = cast(%TestSchema{}, %{bit_size: ""}, [:bit_size])

      assert errors_on(changeset, :bit_size) == []
      assert get_change(changeset, :bit_size) == nil
    end

    test "invalid format" do
      changeset = cast(%TestSchema{}, %{bit_size: "invalid"}, [:bit_size])

      assert errors_on(changeset, :bit_size) == ["is invalid"]
    end

    test "required validator" do
      changeset =
        %TestSchema{}
        |> cast(%{bit_size: ""}, [:bit_size])
        |> validate_required(:bit_size)

      assert errors_on(changeset, :bit_size) == ["can't be blank"]
    end
  end

  describe "Ecto.Changeset.cast/2 with FileSize.Ecto.BitWithUnit" do
    test "valid when value present" do
      changeset =
        cast(%TestSchema{}, %{bit_size_with_unit: "16 Mbit"}, [
          :bit_size_with_unit
        ])

      assert errors_on(changeset, :bit_size_with_unit) == []

      assert get_change(changeset, :bit_size_with_unit) ==
               FileSize.new(16, :mbit)
    end

    test "valid when value blank" do
      changeset =
        cast(%TestSchema{}, %{bit_size_with_unit: ""}, [:bit_size_with_unit])

      assert errors_on(changeset, :bit_size_with_unit) == []
      assert get_change(changeset, :bit_size_with_unit) == nil
    end

    test "invalid format" do
      changeset =
        cast(%TestSchema{}, %{bit_size_with_unit: "invalid"}, [
          :bit_size_with_unit
        ])

      assert errors_on(changeset, :bit_size_with_unit) == ["is invalid"]
    end

    test "required validator" do
      changeset =
        %TestSchema{}
        |> cast(%{bit_size_with_unit: ""}, [:bit_size_with_unit])
        |> validate_required(:bit_size_with_unit)

      assert errors_on(changeset, :bit_size_with_unit) == ["can't be blank"]
    end
  end

  describe "Ecto.Changeset.cast/2 with FileSize.Ecto.Byte" do
    test "valid when value present" do
      changeset = cast(%TestSchema{}, %{byte_size: "16 MB"}, [:byte_size])

      assert errors_on(changeset, :byte_size) == []
      assert get_change(changeset, :byte_size) == FileSize.new(16_000_000, :b)
    end

    test "valid when value blank" do
      changeset = cast(%TestSchema{}, %{byte_size: ""}, [:byte_size])

      assert errors_on(changeset, :byte_size) == []
      assert get_change(changeset, :byte_size) == nil
    end

    test "invalid format" do
      changeset = cast(%TestSchema{}, %{byte_size: "invalid"}, [:byte_size])

      assert errors_on(changeset, :byte_size) == ["is invalid"]
    end

    test "required validator" do
      changeset =
        %TestSchema{}
        |> cast(%{byte_size: ""}, [:byte_size])
        |> validate_required(:byte_size)

      assert errors_on(changeset, :byte_size) == ["can't be blank"]
    end
  end

  describe "Ecto.Changeset.cast/2 with FileSize.Ecto.ByteWithUnit" do
    test "valid when value present" do
      changeset =
        cast(%TestSchema{}, %{byte_size_with_unit: "16 MB"}, [
          :byte_size_with_unit
        ])

      assert errors_on(changeset, :byte_size_with_unit) == []

      assert get_change(changeset, :byte_size_with_unit) ==
               FileSize.new(16, :mb)
    end

    test "valid when value blank" do
      changeset =
        cast(%TestSchema{}, %{byte_size_with_unit: ""}, [:byte_size_with_unit])

      assert errors_on(changeset, :byte_size_with_unit) == []
      assert get_change(changeset, :byte_size_with_unit) == nil
    end

    test "invalid format" do
      changeset =
        cast(%TestSchema{}, %{byte_size_with_unit: "invalid"}, [
          :byte_size_with_unit
        ])

      assert errors_on(changeset, :byte_size_with_unit) == ["is invalid"]
    end

    test "required validator" do
      changeset =
        %TestSchema{}
        |> cast(%{byte_size_with_unit: ""}, [:byte_size_with_unit])
        |> validate_required(:byte_size_with_unit)

      assert errors_on(changeset, :byte_size_with_unit) == ["can't be blank"]
    end
  end

  defp errors_on(changeset, field) do
    changeset.errors
    |> Keyword.get_values(field)
    |> Enum.map(fn {message, _} -> message end)
  end
end
