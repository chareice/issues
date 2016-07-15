defmodule IssuesTest do
  use ExUnit.Case
  doctest Issues

  import Issues.CLI, only: [parse_args: 1]
  test "the truth" do
    assert 1 + 1 == 2
  end

  test ":help returned whby option parsing with -h and --help options" do
      assert parse_args(["-h", "anything"]) == :help
  end

  test "three arguments returned if givend" do
      assert parse_args(["user", "project", "99"]) == {"user", "project", 99}
  end

  test "two arguments returned default count" do
      assert parse_args(["user", "project"]) == {"user", "project", 4}
  end
end
