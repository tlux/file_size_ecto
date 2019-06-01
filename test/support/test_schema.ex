defmodule TestSchema do
  @moduledoc false

  use Ecto.Schema

  embedded_schema do
    field(:bit_size_with_unit, FileSizeEcto.BitWithUnit)
    field(:bit_size, FileSizeEcto.Bit)
    field(:byte_size_with_unit, FileSizeEcto.ByteWithUnit)
    field(:byte_size, FileSizeEcto.Byte)
  end
end
