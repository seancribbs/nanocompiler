defmodule Nanocompiler.Let do
  defstruct [:binds, :expr]

  @type t() :: %Nanocompiler.Let{
          binds: [{String.t(), Nanocompiler.expr()}],
          expr: Nanocompiler.expr()
        }
end

defmodule Nanocompiler.Prim1 do
  defstruct [:op, :expr]

  @type t() :: %Nanocompiler.Prim1{
          op: :add1 | :sub1,
          expr: Nanocompiler.expr()
        }
end

defmodule Nanocompiler.ID do
  defstruct [:name]

  @type t() :: %Nanocompiler.ID{name: String.t()}
end

defmodule Nanocompiler.Number do
  defstruct [:int]

  @type t() :: %Nanocompiler.Number{int: integer()}
end
