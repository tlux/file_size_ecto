defmodule FileSize.Ecto.Byte do
  @behaviour Ecto.Type

  alias FileSize.Byte

  @impl true
  def type, do: :integer

  @impl true
  def cast(term)

  def cast(%Byte{} = size) do
    {:ok, FileSize.convert(size, :b)}
  end

  def cast(value) when is_integer(value) do
    load(value)
  end

  def cast(value) when is_float(value) do
    value |> trunc() |> load()
  end

  def cast(str) when is_binary(str) do
    case FileSize.parse(str) do
      {:ok, size} -> cast(size)
      {:error, _} -> :error
    end
  end

  def cast(_term), do: :error

  @impl true
  def dump(term)

  def dump(%Byte{} = size) do
    {:ok, FileSize.to_integer(size)}
  end

  def dump(_term), do: :error

  @impl true
  def load(term)

  def load(value) when is_integer(value) do
    {:ok, FileSize.new(value, :b)}
  end

  def load(_term), do: :error
end
