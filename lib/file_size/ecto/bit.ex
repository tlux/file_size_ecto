defmodule FileSize.Ecto.Bit do
  @moduledoc """
  An Ecto type that represents a file size in bits. The value is stored as
  integer in the database.

  ## Example

      defmodule MySchema do
        use Ecto.Schema

        schema "my_table" do
          field :file_size, FileSize.Ecto.Bit
        end
      end
  """

  @behaviour Ecto.Type

  alias FileSize.Bit
  alias FileSize.Ecto.Utils

  @impl true
  def type, do: :integer

  @impl true
  def cast(term)

  def cast(%Bit{} = size) do
    {:ok, FileSize.convert(size, :bit)}
  end

  def cast(%{"bits" => bits}) do
    cast(%{bits: bits})
  end

  def cast(%{"value" => value, "unit" => unit}) do
    cast(%{value: value, unit: unit})
  end

  def cast(%{bits: bits}) when is_integer(bits) do
    load(bits)
  end

  def cast(%{value: value, unit: unit}) do
    with {:ok, value} <- Utils.assert_value(value),
         {:ok, unit} <- Utils.parse_unit_for_type(unit, Bit) do
      {:ok,
       value
       |> FileSize.new(unit)
       |> FileSize.convert(:bit)}
    end
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
