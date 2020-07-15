defmodule FileSize.Ecto.ByteWithUnit do
  @moduledoc """
  An Ecto type that represents a file size in bytes, supporting storage of
  different units. The value is stored as map in the database (i.e. jsonb when
  using PostgreSQL).

  ## Example

      defmodule MySchema do
        use Ecto.Schema

        schema "my_table" do
          field :file_size, FileSize.Ecto.ByteWithUnit
        end
      end
  """

  use Ecto.Type

  alias FileSize.Byte
  alias FileSize.Ecto.Byte, as: ByteType
  alias FileSize.Ecto.Utils

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

  def cast(%{value: value, unit: unit}) do
    with {:ok, value} <- Utils.assert_value(value),
         {:ok, unit} <- parse_unit(unit) do
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
    {:ok,
     %{
       "bytes" => FileSize.to_integer(size),
       "unit" => Utils.serialize_unit(size.unit)
     }}
  end

  def dump(_term), do: :error

  @impl true
  def embed_as(_format), do: :dump

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
    Utils.parse_unit_for_type(unit, Byte)
  end
end
