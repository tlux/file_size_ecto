defmodule FileSizeEcto.Type do
  alias FileSize.Bit
  alias FileSize.Byte
  alias FileSize.Convertible

  defmacro __using__(normalized_unit: unit) do
    quote bind_quoted: [normalized_unit: unit] do
      @behaviour Ecto.Type

      @impl true
      def type, do: :integer

      @impl true
      def cast(term)

      def cast(bytes) when is_integer(bytes) do
        {:ok, FileSize.new(bytes, unquote(normalized_unit))}
      end

      def cast(value) when is_float(value) do
        value |> trunc |> cast()
      end

      def cast(str) when is_binary(str) do
        case FileSize.parse(str) do
          {:ok, size} -> {:ok, FileSize.convert(size, unquote(normalized_unit))}
          {:error, _} -> :error
        end
      end

      def cast(%type{} = size) when type in [Bit, Byte] do
        {:ok, FileSize.convert(size, unquote(normalized_unit))}
      end

      def cast(_), do: :error

      @impl true
      def dump(term) do
        case cast(term) do
          {:ok, size} -> {:ok, Convertible.normalized_value(size)}
          _ -> :error
        end
      end

      @impl true
      def load(term)

      def load(bytes) when is_integer(bytes) do
        {:ok, FileSize.new(bytes, unquote(normalized_unit))}
      end

      def load(_), do: :error
    end
  end
end
