# File Size for Ecto

[![Build Status](https://travis-ci.org/tlux/file_size_ecto.svg?branch=master)](https://travis-ci.org/tlux/file_size_ecto)
[![Hex.pm](https://img.shields.io/hexpm/v/file_size_ecto.svg)](https://hex.pm/packages/file_size_ecto)

Provides types for file sizes that you can use in your Ecto schemata.

This library uses [`file_size`](https://hexdocs.pm/file_size) under the hood
that brings a file size parser, formatter and allows calculation and comparison
of file sizes with different units.

## Prerequisites

* Erlang 20 or greater
* Elixir 1.8 or greater

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `file_size_ecto` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:file_size_ecto, "~> 2.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/file_size_ecto](https://hexdocs.pm/file_size_ecto).

## Usage

### Without Unit

The following unit-less types are available:

* [`FileSize.Ecto.Bit`](https://hexdocs.pm/file_size_ecto/FileSize.Ecto.Bit.html)
* [`FileSize.Ecto.Byte`](https://hexdocs.pm/file_size_ecto/FileSize.Ecto.Byte.html)

Write a migration to add or update your file size field. You can use `:integer`
or `:bigint` as types. If you expect very large file sizes, `:bigint` is
recommended of course.

```elixir
defmodule MyProject.Migrations.AddFileSizeToMyTable
  use Ecto.Migration

  def up do
    alter table(:my_table) do
      add :file_size, :bigint
    end
  end
end
```

Update your schema:

```elixir
defmodule MySchema do
  use Ecto.Schema

  schema "my_table" do
    # ...

    field :file_size, FileSize.Ecto.Byte
  end
end
```

You can store your file size like this:

```elixir
record = Repo.get(MySchema, 123)

updated_record =
  record
  |> Echo.Changeset.change(file_size: FileSize.new(2, :mb))
  |> Repo.update!()

updated_record.file_size
# => #FileSize<"2000000 B">
```

Or, when working with user input:

```elixir
updated_record
  record
  |> Echo.Changeset.cast(%{file_size: "4 KiB"}, [:file_size])
  |> Repo.update!()

updated_record.file_size
# => #FileSize<"4096 B">
```

Note that the file size is always converted to the base unit (bit or byte) when
storing it in the database, because no unit information is available. Read the
next section if you want to find out how to store the size unit together with
the value.

### With Unit

The following types with units are available:

* [`FileSize.Ecto.BitWithUnit`](https://hexdocs.pm/file_size_ecto/FileSize.Ecto.BitWithUnit.html)
* [`FileSize.Ecto.ByteWithUnit`](https://hexdocs.pm/file_size_ecto/FileSize.Ecto.ByteWithUnit.html)

Write a migration to add or update your file size field. The value is stored in
a `:map` field. This map contains the as bits or bytes and the unit.

```elixir
defmodule MyProject.Migrations.AddFileSizeToMyTable
  use Ecto.Migration

  def up do
    alter table(:my_table) do
      add :file_size, :map
    end
  end
end
```

Update your schema:

```elixir
defmodule MySchema do
  use Ecto.Schema

  schema "my_table" do
    # ...

    field :file_size, FileSize.Ecto.ByteWithUnit
  end
end
```

You can store your file size like this:

```elixir
record = Repo.get(MySchema, 123)

updated_record =
  record
  |> Echo.Changeset.change(file_size: FileSize.new(2, :mb))
  |> Repo.update!()

updated_record.file_size
# => #FileSize<"2 MB">
```

Or, when working with user input:

```elixir
updated_record
  record
  |> Echo.Changeset.cast(%{file_size: "4 KiB"}, [:file_size])
  |> Repo.update!()

updated_record.file_size
# => #FileSize<"4 KiB">
```

## Docs

Documentation is available on [HexDocs](https://hexdocs.pm/file_size_ecto).
