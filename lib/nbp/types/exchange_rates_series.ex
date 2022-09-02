defmodule NBP.Types.ExchangeRatesSeries do
  @type t :: %__MODULE__{
    table: NBP.currency_table_t(),
    currency: String.t(),
    code: NBP.currency_code_t(),
    rates: [NBP.Types.ExchangeRate.t()],
  }

  defstruct table: nil, currency: nil, code: nil, rates: []
end
