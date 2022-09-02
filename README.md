[![Hex.pm](https://img.shields.io/hexpm/v/nbp.svg)](http://hex.pm/packages/nbp)
[![Hex.pm](https://img.shields.io/hexpm/dt/nbp.svg)](https://hex.pm/packages/nbp)
[![Hex.pm](https://img.shields.io/hexpm/dw/nbp.svg)](https://hex.pm/packages/nbp)

# NBP

This package implements a [public API](http://api.nbp.pl) of the National Bank of 
Poland (in Polish: NBP or Narodowy Bank Polski). 

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `nbp` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:nbp, "~> 0.1.0"}
  ]
end
```

## Additional dependencies

As it uses [Tesla](https://github.com/teamon/tesla) underneath, you
have to follow its installation instructions. Specifically, you have to
install JSON library and you probably should install a HTTP client library
as default HTTP client based on `httpc` does not validate SSL certificates.

For example, add Hackney to the dependencies in `mix.exs`:

```elixir
defp deps do
  [
    {:hackney, "~> 1.16.0"},
  ]
end
```

Configure default adapter in `config/config.exs` (optional).

```elixir
config :tesla, adapter: Tesla.Adapter.Hackney
```

See [Tesla](https://github.com/teamon/tesla)'s README for list of
supported HTTP and JSON libraries.

## Configuration

### Base URL

By default, the API sends requests to the production API. If you want to
send it anywhere else, e.g. for proxying through some other service, you 
can add the following to the `config/config.exs`:

```elixir
config :nbp, :base_url, "https://api.example.com"
```

### User Agent

It is a good idea to override the default value of the User-Agent header added
to the requests to something that clearly identifies your application name and
version. If you want to do this, you can add the following to the `config/config.exs`:

```elixir
config :nbp, :user_agent, "MyApp/1.0.0"
```

## Usage

Sample requests:

```elixir
NBP.exchange_rate_recent('A', 'USD')
NBP.exchange_rate_last('A', 'USD', 10)
NBP.exchange_rate_today('A', 'USD')
NBP.exchange_rate_date('A', 'USD', Date.utc_today())
NBP.exchange_rate_range('A', 'USD', Date.from_iso8601!("2021-10-10"), Date.from_iso8601!("2021-11-10"))
```

## Documentation

The docs can be found at 
[https://hexdocs.pm/nbp](https://hexdocs.pm/nbp).


## License

MIT

## Authors

Marcin Lewandowski