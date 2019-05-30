defmodule FileSizeEcto.Type do
  alias FileSize.Bit
  alias FileSize.Byte
  alias FileSize.Convertible

  defmacro __using__(unit: unit) do
    quote bind_quoted: [unit: unit] do
      @behaviour Ecto.Type

      @impl true
      def type, do: :integer

      @impl true
      def cast(term) do
        unquote(__MODULE__).cast(unquote(unit), term)
      end

      @impl true
      def dump(term) do
        unquote(__MODULE__).dump(unquote(unit), term)
      end

      @impl true
      def load(term) do
        unquote(__MODULE__).load(unquote(unit), term)
      end
    end
  end

  @spec cast(FileSize.unit(), term) ::
          {:ok, FileSize.t()} | {:error, Keyword.t()} | :error
  def cast(unit, term)

  def cast(unit, value) when is_integer(value) do
    {:ok, FileSize.new(value, unit)}
  end

  def cast(unit, value) when is_float(value) do
    cast(unit, trunc(value))
  end

  def cast(unit, str) when is_binary(str) do
    case FileSize.parse(str) do
      {:ok, size} -> {:ok, FileSize.convert(size, unit)}
      {:error, _} -> :error
    end
  end

  def cast(unit, %type{} = size) when type in [Bit, Byte] do
    {:ok, FileSize.convert(size, unit)}
  end

  def cast(_unit, _term), do: :error

  @spec dump(FileSize.unit(), term) :: {:ok, integer} | :error
  def dump(unit, term) do
    case cast(unit, term) do
      {:ok, size} -> {:ok, Convertible.normalized_value(size)}
      _ -> :error
    end
  end

  @spec load(FileSize.unit(), term) :: {:ok, FileSize.t()} | :error
  def load(unit, term)

  def load(unit, value) when is_integer(value) do
    {:ok, FileSize.new(value, unit)}
  end

  def load(_unit, _term), do: :error
end
