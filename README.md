# Cwk1

## How to run my solutions:
To run locally on version n with p number of peers, use the following commands:
make run VERSION=n PEERS=p

To run on docker on version n with p number of peers, use the following commands:
make drun dockerrun VERSION=n PEERS=p

Note that after running this command, use commands: make kill
or
make down

to stop and remove the containers.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `cwk1` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:cwk1, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/cwk1](https://hexdocs.pm/cwk1).
