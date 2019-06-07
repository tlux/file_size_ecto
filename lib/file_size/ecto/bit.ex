defmodule FileSize.Ecto.Bit do
  @behaviour Ecto.Type

  alias FileSize.Bit

  @impl true
  def type, do: :integer

  @impl true
  def cast(term)

  def cast(%Bit{} = size) do
    {:ok, FileSize.convert(size, :bit)}
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

  def dump(%Bit{} = size) do
    {:ok, FileSize.to_integer(size)}
  end

  def dump(_term), do: :error

  @impl true
  def load(term)

  def load(value) when is_integer(value) do
    {:ok, FileSize.new(value, :bit)}
  end

  def load(_term), do: :error
end
