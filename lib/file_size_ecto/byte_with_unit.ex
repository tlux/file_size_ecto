defmodule FileSizeEcto.ByteWithUnit do
  @behaviour Ecto.Type

  alias FileSize.Byte
  alias FileSizeEcto.Byte, as: ByteType
  alias FileSizeEcto.Utils

  @impl true
  def type, do: :map

  @impl true
  def cast(term)

  def cast(%Byte{} = size) do
    {:ok, size}
  end

  def cast(%{"bytes" => bytes, "unit" => unit}) do
    cast(%{bytes: bytes, unit: unit})
  end

  def cast(%{"value" => value, "unit" => unit}) do
    cast(%{value: value, unit: unit})
  end

  def cast(%{bytes: bytes, unit: unit}) when is_integer(bytes) do
    with {:ok, unit} <- parse_unit(unit) do
      {:ok, FileSize.from_bytes(bytes, unit)}
    end
  end

  def cast(%{value: value, unit: unit}) when is_number(value) do
    with {:ok, unit} <- parse_unit(unit) do
      {:ok, FileSize.new(value, unit)}
    end
  end

  def cast(str) when is_binary(str) do
    case FileSize.parse(str) do
      {:ok, %Byte{} = size} -> {:ok, size}
      _ -> :error
    end
  end

  def cast(term) do
    ByteType.cast(term)
  end

  @impl true
  def dump(term)

  def dump(%Byte{} = size) do
    {:ok, %{"bytes" => size.bytes, "unit" => to_string(size.unit)}}
  end

  def dump(_term), do: :error

  @impl true
  def load(term)

  def load(%{"bytes" => bytes, "unit" => unit_str})
      when is_integer(bytes) and is_binary(unit_str) do
    with {:ok, unit} <- parse_unit(unit_str) do
      {:ok, FileSize.from_bytes(bytes, unit)}
    end
  end

  def load(_term), do: :error

  defp parse_unit(unit) do
    case Utils.parse_unit(unit) do
      {:ok, %{mod: Byte, name: name}} ->
        {:ok, name}

      _ ->
        :error
    end
  end
end
