defmodule NBP.Types.ExchangeRate do
  @type t :: %__MODULE__{
    no: NBP.currency_table_no_t(),
    effective_date: Date.t(),
    mid: Decimal.t(),
  }

  defstruct no: nil, effective_date: nil, mid: nil
end
