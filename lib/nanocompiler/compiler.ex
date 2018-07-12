defmodule Nanocompiler.Compiler do
  # We will use the BEAM assembler to construct the bytecode. This is the
  # first part of every program we will compile.
  @prelude [
    ## We are compiling to a module which has one 0-arity export.
    {:module, Program},
    {:exports, [main: 0]},
    {:attributes, []},

    ## These will need to change as we make our language more sophisticated. For
    ## some reason the .S output of the Erlang compiler leaves the labels count
    ## 1 higher than the number of labels in the file.
    {:labels, 3},

    ## The entry point of our program. I'm not sure yet what the fourth entry in
    ## the tuple is, but the third is definitely the arity.
    {:function, :main, 0, 2},
    {:label, 1},
    {:line, []},
    {:func_info, {:atom, Program}, {:atom, :main}, 0},
    {:label, 2}

    ## Our compiled code comes after this label, and before the return.
  ]

  @doc """
  Compiles an input program into BEAM assembly (as iodata) which will be written
  to a file and later assembled by the BEAM assembler into a .beam.
  """
  @spec compile_to_string(Nanocompiler.expr()) :: iodata()
  def compile_to_string(prog) do
    beam = @prelude ++ compile(prog) ++ [:return]

    for op <- beam do
      :io_lib.format('~p.~n', [op])
    end
  end

  @doc """
  Converts our abstract operations into BEAM instructions.
  """
  def op_to_beam(_op) do
    # TODO
    nil
  end

  alias Nanocompiler.{Number, Prim1}

  # @spec compile(Nanocompiler.expr()) :: [ASM.instruction()]
  def compile(prog) do
    case prog do
      %Prim1{op: op, expr: e} ->
        bif =
          case op do
            :add1 -> :+
            :sub1 -> :-
          end

        compile(e) ++
          [
            {:gc_bif, bif, {:f, 0}, 1, [{:x, 0}, {:integer, 1}], {:x, 0}}
          ]

      %Number{int: i} ->
        [{:move, {:integer, i}, {:x, 0}}]

      _ ->
        raise "Expression #{inspect(prog)} not implemented!"
    end
  end
end
