defmodule FileSizeEcto.Type.ByteWithUnit do
  @behaviour Ecto.Type

  alias FileSize.Convertible
  alias FileSize.InvalidUnitError
  alias FileSizeEcto.Type.Byte, as: ByteType

  @impl true
  def type, do: :map

  @impl true
  def cast(term)

  def cast(%{"bytes" => _, "unit" => _} = term) do
    load(term)
  end

  def cast(term) do
    ByteType.cast(term)
  end

  @impl true
  def dump(term) do
    case cast(term) do
      {:ok, size} ->
        {:ok, %{
          "bytes" => Convertible.normalized_value(size),
          "unit" => to_string(size.unit)
        }}

      _ ->
        :error
    end
  end

  @impl true
  def load(term)

  def load(%{"bytes" => bytes, "unit" => unit_str})
  when is_integer(bytes) and is_binary(unit_strs) do
    unit = String.to_existing_atom(unit_str)
    {:ok, FileSize.from_bytes(bytes, unit)}
  rescue
    error in [ArgumentError, InvalidUnitError] ->
      :error
  end

  def load(_term), do: :error
end
