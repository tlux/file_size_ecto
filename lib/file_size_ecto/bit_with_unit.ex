defmodule FileSizeEcto.BitWithUnit do
  @behaviour Ecto.Type

  alias FileSize.Bit
  alias FileSizeEcto.Bit, as: BitType
  alias FileSizeEcto.Utils

  @impl true
  def type, do: :map

  @impl true
  def cast(term)

  def cast(%Bit{} = size) do
    {:ok, size}
  end

  def cast(%{"bits" => bits, "unit" => unit}) do
    cast(%{bits: bits, unit: unit})
  end

  def cast(%{"value" => value, "unit" => unit}) do
    cast(%{value: value, unit: unit})
  end

  def cast(%{bits: bits, unit: unit}) when is_integer(bits) do
    with {:ok, unit} <- parse_unit(unit) do
      {:ok, FileSize.from_bits(bits, unit)}
    end
  end

  def cast(%{value: value, unit: unit}) when is_number(value) do
    with {:ok, unit} <- parse_unit(unit) do
      {:ok, FileSize.new(value, unit)}
    end
  end

  def cast(str) when is_binary(str) do
    case FileSize.parse(str) do
      {:ok, %Bit{} = size} -> {:ok, size}
      _ -> :error
    end
  end

  def cast(term) do
    BitType.cast(term)
  end

  @impl true
  def dump(term)

  def dump(%Bit{} = size) do
    {:ok, %{"bits" => size.bits, "unit" => to_string(size.unit)}}
  end

  def dump(_term), do: :error

  @impl true
  def load(term)

  def load(%{"bits" => bits, "unit" => unit_str})
      when is_integer(bits) and is_binary(unit_str) do
    with {:ok, unit} <- parse_unit(unit_str) do
      {:ok, FileSize.from_bits(bits, unit)}
    end
  end

  def load(_term), do: :error

  defp parse_unit(unit) do
    case Utils.parse_unit(unit) do
      {:ok, %{mod: Bit, name: name}} ->
        {:ok, name}

      _ ->
        :error
    end
  end
end
