defmodule Nanocompiler do
  alias Nanocompiler.{Let, Prim1, ID, Number}

  @type expr() :: Let.t() | Prim1.t() | ID.t() | Number.t()

  def run(_filename) do
    :ok
  end
end
