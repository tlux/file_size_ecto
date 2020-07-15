defmodule FileSize.Ecto.Byte do
  @moduledoc """
  An Ecto type that represents a file size in bytes. The value is stored as
  integer in the database.

  ## Example

      defmodule MySchema do
        use Ecto.Schema

        schema "my_table" do
          field :file_size, FileSize.Ecto.Byte
        end
      end
  """

  use Ecto.Type

  alias FileSize.Byte
  alias FileSize.Ecto.Utils

  @impl true
  def type, do: :integer

  @impl true
  def cast(term)

  def cast(%Byte{} = size) do
    {:ok, FileSize.convert(size, :b)}
  end

  def cast(%{"bytes" => bytes}) do
    cast(%{bytes: bytes})
  end

  def cast(%{"value" => value, "unit" => unit}) do
    cast(%{value: value, unit: unit})
  end

  def cast(%{bytes: bytes}) when is_integer(bytes) do
    load(bytes)
  end

  def cast(%{value: value, unit: unit}) do
    with {:ok, value} <- Utils.assert_value(value),
         {:ok, unit} <- Utils.parse_unit_for_type(unit, Byte) do
      {:ok,
       value
       |> FileSize.new(unit)
       |> FileSize.convert(:b)}
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

  def dump(%Byte{} = size) do
    {:ok, FileSize.to_integer(size)}
  end

  def dump(_term), do: :error

  @impl true
  def embed_as(_format), do: :self

  @impl true
  defdelegate equal?(size, other_size), to: Utils

  @impl true
  def load(term)

  def load(value) when is_integer(value) do
    {:ok, FileSize.new(value, :b)}
  end

  def load(_term), do: :error
end
