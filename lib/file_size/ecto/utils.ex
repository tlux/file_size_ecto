defmodule FileSize.Ecto.Utils do
  @moduledoc false

  alias FileSize.Units

  if Code.ensure_loaded?(Decimal) do
    @spec assert_value(value) :: {:ok, value} | :error
          when value: number | Decimal.t()
    def assert_value(%Decimal{} = value), do: {:ok, value}
  else
    @spec assert_value(value) :: {:ok, value} | :error when value: number
  end

  def assert_value(value) when is_number(value), do: {:ok, value}
  def assert_value(_), do: :error

  @spec equal?(FileSize.t() | String.t(), FileSize.t() | String.t()) :: boolean
  def equal?(nil, nil), do: true

  def equal?(nil, _), do: false

  def equal?(_, nil), do: false

  def equal?(size, other_size) do
    with {:ok, size} <- FileSize.parse(size),
         {:ok, other_size} <- FileSize.parse(other_size) do
      FileSize.equals?(size, other_size)
    else
      _ -> false
    end
  end

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
    |> String.to_atom()
    |> Units.fetch()
  end

  defp parse_unit(unit), do: Units.fetch(unit)

  @spec serialize_unit(FileSize.unit() | String.t()) :: String.t()
  def serialize_unit(unit), do: to_string(unit)
end
