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

    def process({user, project, _count}) do
        Issues.GithubIssues.fetch(user, project)
        |> decode_response
    end

    def decode_response({:ok, body}) do
        body
        |> convert_to_list_of_map
    end

    def decode_response({:error, body}) do
        IO.puts "Eror fetching from Github"
        System.halt(2)
    end

    def convert_to_list_of_map(list) do
        list
        |> Enum.map(&Enum.into(&1, %{}))
    end
end