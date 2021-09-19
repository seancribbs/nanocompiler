defmodule Nanocompiler.TestCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      import Nanocompiler.TestHelpers
    end
  end

  setup_all do
    File.mkdir_p!("output")
    :ok
  end
end

defmodule Nanocompiler.TestHelpers do
  import ExUnit.Assertions
  alias Nanocompiler.Runner

  defmacro compiler_cases(label, cases) do
    for {{prog, result}, idx} <- Enum.with_index(cases) do
      quote do
        test "#{unquote(label)}-#{unquote(idx)}" do
          assert_run unquote(prog), "#{unquote(label)}#{unquote(idx)}", unquote(result)
        end
      end
    end
  end

  def assert_run(program_str, outfile, expected) do
    full_outfile = Path.join("output/", outfile)

    with {:parse, {:ok, parsed}} <- {:parse, Runner.parse_string(program_str)},
         {:run, :ok} <- {:run, Runner.run(parsed, "Elixir.Program")},
         {:ok, result} <- File.read("Elixir.Program.out") do
      copy_results(full_outfile)
      assert result == expected
    else
      {:parse, err} ->
        raise ExUnit.AssertionError, message: "Parsing program failed: #{inspect(err)}"

      {:run, other} ->
        raise ExUnit.AssertionError,
          message: "Compiling and running program failed: #{inspect(other)}"

      {:error, posix} ->
        raise ExUnit.AssertionError, message: "Could not read output file: #{inspect(posix)}"
    end
  end

  def assert_error(program_str, outfile, errmsg) do
    full_outfile = Path.join("output/", outfile)

    try do
      {:ok, parsed} = Runner.parse_string(program_str)
      :ok = Runner.run(parsed, "Elixir.Program")
      copy_results(full_outfile)
      {:ok, _result} = File.read("Elixir.Program.out")
    rescue
      err -> assert String.contains?(inspect(err), errmsg)
    else
      outcome ->
        raise ExUnit.AssertionError, message: "Expected error", left: errmsg, right: outcome
    end
  end

  defp copy_results(full_outfile) do
    for ext <- ~w(S beam out) do
      File.cp!("Elixir.Program.#{ext}", "#{full_outfile}.#{ext}")
    end
  end
end

ExUnit.start()
