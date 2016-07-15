defmodule Issues.CLI do
    @default_count 4

    def run(argv) do
        argv
          |> parse_args
          |> process
    end

    def parse_args(argv) do
        parse = OptionParser.parse(argv, switches: [help: :boolean],
                                         aliases: [h: :help])

        case parse do
            { [help: true], _, _ } 
              -> :help
            {_, [user, repositry, count], _} 
              -> {user, repositry, String.to_integer(count)}
            {_, [user, repositry], _}
              -> {user, repositry, @default_count}
            _ -> :help
        end
    end

    def process(:help) do
        IO.puts """
        usage: issues <user> <project> [count | #{@default_count}]
        """

        System.halt(0)
    end

    def process({user, project, count}) do
        Issues.GithubIssues.fetch(user, project)
        |> decode_response
        |> convert_to_list_of_map
        |> sort_into_ascending_order
        |> Enum.take(count)
    end

    def decode_response({:ok, body}) do
        body
    end

    def decode_response({:error, body}) do
        IO.puts "Eror fetching from Github"
        System.halt(2)
    end

    def convert_to_list_of_map(list) do
        list
        |> Enum.map(&Enum.into(&1, %{}))
    end

    def sort_into_ascending_order(list_of_issues) do
        Enum.sort list_of_issues,
            fn i1, i2 -> i1["created_at"] <= i2["created_at"] end
    end
end