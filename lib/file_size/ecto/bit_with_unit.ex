defmodule FileSize.Ecto.BitWithUnit do
  @moduledoc """
  An Ecto type that represents a file size in bits, supporting storage of
  different units. The value is stored as map in the database (i.e. jsonb when
  using PostgreSQL).

  ## Example

      defmodule MySchema do
        use Ecto.Schema

        schema "my_table" do
          field :file_size, FileSize.Ecto.BitWithUnit
        end
      end
  """

  use Ecto.Type

  alias FileSize.Bit
  alias FileSize.Ecto.Bit, as: BitType
  alias FileSize.Ecto.Utils

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

  def cast(%{value: value, unit: unit}) do
    with {:ok, value} <- Utils.assert_value(value),
         {:ok, unit} <- parse_unit(unit) do
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
    {:ok,
     %{
       "bits" => FileSize.to_integer(size),
       "unit" => Utils.serialize_unit(size.unit)
     }}
  end

  def dump(_term), do: :error

  @impl true
  def embed_as(_format), do: :dump

  @impl true
  defdelegate equal?(size, other_size), to: Utils

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
    Utils.parse_unit_for_type(unit, Bit)
  end
end
