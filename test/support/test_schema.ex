defmodule TestSchema do
  @moduledoc false

  use Ecto.Schema

  embedded_schema do
    field :bit_size, FileSizeEcto.Type.Bit
    field :byte_size, FileSizeEcto.Type.Byte
  end
end
