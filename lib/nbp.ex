defmodule NBP do
  alias NBP.{Request,Response}

  @typedoc """
  A currency table identifier. Currency rates are split between three
  tables, A, B and C and you have to pass appropriate table identifier
  for a given currency. This is not case sensitive.
  """
  @type currency_table_t :: 'A' | 'B' | 'C' | 'a' | 'b' | 'c'

  @typedoc """
  Three-letter currency code, as in ISO 4217. This is not case sensitive.
  """
  @type currency_code_t :: charlist()

  @typedoc """
  Currency table number. Daily currency rate tables receive unique numbers once
  they are published.
  """
  @type currency_table_no_t() :: String.t()

  @doc """
  Returns the most recent exchange rate for given currency table and currency code.
  """
  @spec exchange_rate_recent(currency_table_t(), currency_code_t()) :: {:ok, NBP.Tyles.ExchangeRatesSeries.t()} | {:error, any}
  def exchange_rate_recent(currency_table, currency_code) do
    do_exchange_rate_request("/api/exchangerates/rates/#{URI.encode(to_string(currency_table))}/#{URI.encode(to_string(currency_code))}")
  end

  @doc """
  Returns last *count* of exchange rates for given currency table and currency code.
  """
  @spec exchange_rate_last(currency_table_t(), currency_code_t(), pos_integer()) :: {:ok, NBP.Tyles.ExchangeRatesSeries.t()} | {:error, any}
  def exchange_rate_last(currency_table, currency_code, count) do
    do_exchange_rate_request("/api/exchangerates/rates/#{URI.encode(to_string(currency_table))}/#{URI.encode(to_string(currency_code))}/last/#{URI.encode(to_string(count))}")
  end

  @doc """
  Returns the exchange rate for today for given currency table and currency code
  or no data if no currency rate was published for today.
  """
  @spec exchange_rate_today(currency_table_t(), currency_code_t()) :: {:ok, NBP.Tyles.ExchangeRatesSeries.t()} | {:error, any}
  def exchange_rate_today(currency_table, currency_code) do
    do_exchange_rate_request("/api/exchangerates/rates/#{URI.encode(to_string(currency_table))}/#{URI.encode(to_string(currency_code))}/today/")
  end

  @doc """
  Returns the exchange rate for given date, currency table and currency code or no data
  if no currency rates were published for given date. The oldest data available is from
  2 Jan 2022.
  """
  @spec exchange_rate_date(currency_table_t(), currency_code_t(), Date.t()) :: {:ok, NBP.Tyles.ExchangeRatesSeries.t()} | {:error, any}
  def exchange_rate_date(currency_table, currency_code, date) do
    do_exchange_rate_request("/api/exchangerates/rates/#{URI.encode(to_string(currency_table))}/#{URI.encode(to_string(currency_code))}/#{Date.to_iso8601(date)}/")
  end

  @doc """
  Returns exchange rates for date range for given currency table and currency code
  or no data if no currency rates were published for given range. The maximum range is
  93 days.
  """
  @spec exchange_rate_range(currency_table_t(), currency_code_t(), Date.t(), Date.t()) :: {:ok, NBP.Tyles.ExchangeRatesSeries.t()} | {:error, any}
  def exchange_rate_range(currency_table, currency_code, start_date, end_date) do
    do_exchange_rate_request("/api/exchangerates/rates/#{URI.encode(to_string(currency_table))}/#{URI.encode(to_string(currency_code))}/#{Date.to_iso8601(start_date)}/#{Date.to_iso8601(end_date)}/")
  end

  defp do_exchange_rate_request(path) do
    case Request.get(path) do
      {:ok, %Response{body: body}} ->
        case NBP.Parser.ExchangeRatesSeries.parse(body) do
          {:ok, result} ->
            {:ok, result}
          {:error, reason} ->
            {:error, {:parse, reason}}
        end

      {:error, reason} ->
        {:error, {:request, reason}}
    end
  end
end
