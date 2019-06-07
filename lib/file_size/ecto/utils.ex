defmodule FileSize.Ecto.Utils do
  @moduledoc false

  alias FileSize.Units

  @spec parse_unit_for_type(FileSize.unit() | String.t(), module) ::
          {:ok, FileSize.unit()} | :error
  def parse_unit_for_type(unit, mod) do
    case parse_unit(unit) do
      {:ok, %{mod: ^mod, name: name}} ->
        {:ok, name}

      _ ->
        :error
    end
  end

  defp parse_unit(unit_str) when is_binary(unit_str) do
    unit_str
    |> String.to_existing_atom()
    |> Units.fetch()
  rescue
    ArgumentError -> :error
  end

  defp parse_unit(unit), do: Units.fetch(unit)

  @spec serialize_unit(FileSize.unit() | String.t()) :: String.t()
  def serialize_unit(unit), do: to_string(unit)
end
