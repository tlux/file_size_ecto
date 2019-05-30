defmodule TestSchema do
  @moduledoc false

  use Ecto.Schema

  embedded_schema do
    field :bit_file_size, FileSizeEcto.Type.Bit
    field :byte_file_size, FileSizeEcto.Type.Byte
  end
end
