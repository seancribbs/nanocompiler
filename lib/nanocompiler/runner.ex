defmodule Nanocompiler.Runner do
  alias Nanocompiler.Compiler

  def parse_file(fname) do
    with {:ok, str} <- File.read(fname) do
      parse_string(str)
    end
  end

  def parse_string(input) when is_binary(input) do
    input
    |> to_charlist
    |> parse_string()
  end

  def parse_string(input) when is_list(input) do
    input
    |> :nano_lexer.string()
    |> parse()
  end

  def parse({:ok, tokens, _endl}) do
    :nano_parser.parse(tokens)
  end

  def parse({line, _, _} = errinfo) when is_integer(line) do
    {:error, :nano_lexer.format_error(errinfo)}
  end

  def run(program, outfilename) do
    # Between test runs, it is important to purge the module from memory. In the
    # future we could allow the caller to define the name of the module.
    :code.purge(Program)
    :ok = compile(program, outfilename)

    resultfilename = outfilename <> ".out"

    # We have to use apply to prevent xref warnings for the unknown module.
    :erlang.apply(Program, :main, [])
    |> inspect(pretty: false, limit: :infinity, width: :infinity)
    |> write_file(resultfilename)

    :ok
  end

  defp compile(program, filename) do
    outfilename = filename <> ".S"

    program
    |> Compiler.compile_to_string()
    |> write_file(filename)

    assemble(outfilename)
  end

  defp assemble(file) do
    case :compile.file(to_charlist(file), [:from_asm]) do
      {:ok, _module} -> :ok
      {:ok, _module, _warnings_or_binary} -> :ok
      {:ok, _module, _binary, _warning} -> :ok
      other -> {:assemble, other}
    end
  end

  @compile :inline
  defp write_file(content, filename) do
    File.write!(filename, content)
  end
end
