defmodule TestSchema do
  @moduledoc false

  use Ecto.Schema

  embedded_schema do
    field(:bit_size_with_unit, FileSize.Ecto.BitWithUnit)
    field(:bit_size, FileSize.Ecto.Bit)
    field(:byte_size_with_unit, FileSize.Ecto.ByteWithUnit)
    field(:byte_size, FileSize.Ecto.Byte)
  end
end
