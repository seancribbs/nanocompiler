defmodule Nanocompiler.TestCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      import Nanocompiler.TestHelpers
    end
  end
end

defmodule Nanocompiler.TestHelpers do
  alias Nanocompiler.Runner

  def assert_run(program_str, outfile, expected) do
    full_outfile = Path.join("output/", outfile)

    with {:parse, {:ok, parsed}} <- {:parse, Runner.parse_string(program_str)},
         {:run, :ok} <- {:run, Runner.run(parsed, full_outfile)},
         {:ok, result} <- File.read(full_outfile <> ".out") do
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
      :ok = Runner.run(parsed, full_outfile)
      {:ok, result} = File.read(full_outfile <> ".out")
    rescue
      err -> assert String.contains?(inspect(err), errmsg)
    else
      outcome ->
        raise ExUnit.AssertionError, message: "Expected error", left: errmsg, right: outcome
    end
  end
end

ExUnit.start()
