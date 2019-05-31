defmodule FileSizeEcto.Utils do
  @moduledoc false

  alias FileSize.UnitInfo
  alias FileSize.Units

  @spec parse_unit(FileSize.unit() | String.t()) ::
          {:ok, UnitInfo.t()} | :error
  def parse_unit(unit) when is_binary(unit) do
    unit
    |> String.to_existing_atom()
    |> Units.unit_info()
  rescue
    ArgumentError -> :error
  end

  def parse_unit(unit) do
    Units.unit_info(unit)
  end
end
