defmodule FileSizeEcto.Byte do
  @behaviour Ecto.Type

  alias FileSize.Bit
  alias FileSize.Byte

  @impl true
  def type, do: :integer

  @impl true
  def cast(term)

  def cast(bytes) when is_integer(bytes) do
    {:ok, FileSize.new(bytes, :b)}
  end

  def cast(value) when is_float(value) do
    value |> trunc |> cast()
  end

  def cast(str) when is_binary(str) do
    case FileSize.parse(str) do
      {:ok, size} -> {:ok, FileSize.convert(size, :b)}
      {:error, _} -> :error
    end
  end

  def cast(%type{} = size) when type in [Bit, Byte] do
    {:ok, FileSize.convert(size, :b)}
  end

  def cast(_), do: :error

  @impl true
  def dump(term) do
    case cast(term) do
      {:ok, size} -> {:ok, size.bytes}
      _ -> :error
    end
  end

  @impl true
  def load(term)

  def load(bytes) when is_integer(bytes) do
    {:ok, FileSize.new(bytes, :b)}
  end

  def load(_), do: :error
end
