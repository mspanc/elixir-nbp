defmodule NBP.Parser.ExchangeRatesSeriesTest do
  use ExUnit.Case

  @valid_xml_single_rate """
<?xml version="1.0" encoding="utf-8"?>
<ExchangeRatesSeries xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
    <Table>A</Table>
    <Currency>dolar amerykański</Currency>
    <Code>USD</Code>
    <Rates>
        <Rate>
            <No>170/A/NBP/2022</No>
            <EffectiveDate>2022-09-02</EffectiveDate>
            <Mid>4.7276</Mid>
        </Rate>
    </Rates>
</ExchangeRatesSeries>
"""

  @valid_xml_multiple_rates """
<?xml version="1.0" encoding="utf-8"?>
<ExchangeRatesSeries xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
    <Table>A</Table>
    <Currency>dolar amerykański</Currency>
    <Code>USD</Code>
    <Rates>
        <Rate>
            <No>161/A/NBP/2022</No>
            <EffectiveDate>2022-08-22</EffectiveDate>
            <Mid>4.7427</Mid>
        </Rate>
        <Rate>
            <No>162/A/NBP/2022</No>
            <EffectiveDate>2022-08-23</EffectiveDate>
            <Mid>4.8030</Mid>
        </Rate>
        <Rate>
            <No>163/A/NBP/2022</No>
            <EffectiveDate>2022-08-24</EffectiveDate>
            <Mid>4.8029</Mid>
        </Rate>
        <Rate>
            <No>164/A/NBP/2022</No>
            <EffectiveDate>2022-08-25</EffectiveDate>
            <Mid>4.7546</Mid>
        </Rate>
        <Rate>
            <No>165/A/NBP/2022</No>
            <EffectiveDate>2022-08-26</EffectiveDate>
            <Mid>4.7465</Mid>
        </Rate>
        <Rate>
            <No>166/A/NBP/2022</No>
            <EffectiveDate>2022-08-29</EffectiveDate>
            <Mid>4.7821</Mid>
        </Rate>
        <Rate>
            <No>167/A/NBP/2022</No>
            <EffectiveDate>2022-08-30</EffectiveDate>
            <Mid>4.7210</Mid>
        </Rate>
        <Rate>
            <No>168/A/NBP/2022</No>
            <EffectiveDate>2022-08-31</EffectiveDate>
            <Mid>4.7360</Mid>
        </Rate>
        <Rate>
            <No>169/A/NBP/2022</No>
            <EffectiveDate>2022-09-01</EffectiveDate>
            <Mid>4.6959</Mid>
        </Rate>
        <Rate>
            <No>170/A/NBP/2022</No>
            <EffectiveDate>2022-09-02</EffectiveDate>
            <Mid>4.7276</Mid>
        </Rate>
    </Rates>
</ExchangeRatesSeries>
"""

  test "parses valid XML response that contains a single rate" do
    assert NBP.Parser.ExchangeRatesSeries.parse(@valid_xml_single_rate) == {:ok, %NBP.Types.ExchangeRatesSeries{
      table: 'A',
      currency: "dolar amerykański",
      code: 'USD',
      rates: [
        %NBP.Types.ExchangeRate{
          no: "170/A/NBP/2022",
          effective_date: ~D[2022-09-02],
          mid: Decimal.new("4.7276")
        }
      ]
    }}
  end

  test "parses valid XML response that contains multiple rates" do
    assert NBP.Parser.ExchangeRatesSeries.parse(@valid_xml_multiple_rates) == {:ok,
      %NBP.Types.ExchangeRatesSeries{
        table: 'A',
        currency: "dolar amerykański",
        code: 'USD',
        rates: [
          %NBP.Types.ExchangeRate{
            no: "161/A/NBP/2022",
            effective_date: ~D[2022-08-22],
            mid: Decimal.new("4.7427")
          },
          %NBP.Types.ExchangeRate{
            no: "162/A/NBP/2022",
            effective_date: ~D[2022-08-23],
            mid: Decimal.new("4.8030")
          },
          %NBP.Types.ExchangeRate{
            no: "163/A/NBP/2022",
            effective_date: ~D[2022-08-24],
            mid: Decimal.new("4.8029")
          },
          %NBP.Types.ExchangeRate{
            no: "164/A/NBP/2022",
            effective_date: ~D[2022-08-25],
            mid: Decimal.new("4.7546")
          },
          %NBP.Types.ExchangeRate{
            no: "165/A/NBP/2022",
            effective_date: ~D[2022-08-26],
            mid: Decimal.new("4.7465")
          },
          %NBP.Types.ExchangeRate{
            no: "166/A/NBP/2022",
            effective_date: ~D[2022-08-29],
            mid: Decimal.new("4.7821")
          },
          %NBP.Types.ExchangeRate{
            no: "167/A/NBP/2022",
            effective_date: ~D[2022-08-30],
            mid: Decimal.new("4.7210")
          },
          %NBP.Types.ExchangeRate{
            no: "168/A/NBP/2022",
            effective_date: ~D[2022-08-31],
            mid: Decimal.new("4.7360")
          },
          %NBP.Types.ExchangeRate{
            no: "169/A/NBP/2022",
            effective_date: ~D[2022-09-01],
            mid: Decimal.new("4.6959")
          },
          %NBP.Types.ExchangeRate{
            no: "170/A/NBP/2022",
            effective_date: ~D[2022-09-02],
            mid: Decimal.new("4.7276")
          }
        ]
      }}
  end
end
