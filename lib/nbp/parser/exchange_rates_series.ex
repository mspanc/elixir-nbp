defmodule NBP.Parser.ExchangeRatesSeries do
  @moduledoc """
  Module responsible for parsing response of the currency exchange rate series.
  """

  require Logger

  @spec parse(binary()) :: {:ok, NBP.Types.ExchangeRatesSeries.t()} | {:error, any()}
  def parse(document) do
    case :xmerl_sax_parser.stream(document, [
      event_fun: &handle_xml_event/3,
      event_state: {nil, %NBP.Types.ExchangeRatesSeries{}},
    ]) do
      {:ok, {nil, result}, _rest} ->
        {:ok, result}
      other ->
        {:error, other}
    end
  end

  defp handle_xml_event(:startDocument, _, {nil, series}), do: {nil, series}

  defp handle_xml_event({:startElement, [], 'ExchangeRatesSeries', _, _}, _, {nil, series}), do: {:root, series}

  defp handle_xml_event({:startElement, [], 'Table', _, _}, _, {:root, series}), do: {:table, series}
  defp handle_xml_event({:characters, content}, _, {:table, series}), do: {:table, %{series | table: content}}
  defp handle_xml_event({:endElement, [], 'Table', _}, _, {:table, series}), do: {:root, series}

  defp handle_xml_event({:startElement, [], 'Currency', _, _}, _, {:root, series}), do: {:currency, series}
  defp handle_xml_event({:characters, content}, _, {:currency, series}), do: {:currency, %{series | currency: to_string(content)}}
  defp handle_xml_event({:endElement, [], 'Currency', _}, _, {:currency, series}), do: {:root, series}

  defp handle_xml_event({:startElement, [], 'Code', _, _}, _, {:root, series}), do: {:code, series}
  defp handle_xml_event({:characters, content}, _, {:code, series}), do: {:code, %{series | code: content}}
  defp handle_xml_event({:endElement, [], 'Code', _}, _, {:code, series}), do: {:root, series}

  defp handle_xml_event({:startElement, [], 'Rates', _, _}, _, {:root, series}), do: {:rates, series}

  defp handle_xml_event({:startElement, [], 'Rate', _, _}, _, {:rates, series}), do: {:rate, series, %NBP.Types.ExchangeRate{}}

  defp handle_xml_event({:startElement, [], 'No', _, _}, _, {:rate, series, rate}), do: {:no, series, rate}
  defp handle_xml_event({:characters, content}, _, {:no, series, rate}), do: {:no, series, %{rate | no: to_string(content)}}
  defp handle_xml_event({:endElement, [], 'No', _}, _, {:no, series, rate}), do: {:rate, series, rate}

  defp handle_xml_event({:startElement, [], 'EffectiveDate', _, _}, _, {:rate, series, rate}), do: {:effective_date, series, rate}
  defp handle_xml_event({:characters, content}, _, {:effective_date, series, rate}), do: {:effective_date, series, %{rate | effective_date: Date.from_iso8601!(to_string(content))}}
  defp handle_xml_event({:endElement, [], 'EffectiveDate', _}, _, {:effective_date, series, rate}), do: {:rate, series, rate}

  defp handle_xml_event({:startElement, [], 'Mid', _, _}, _, {:rate, series, rate}), do: {:mid, series, rate}
  defp handle_xml_event({:characters, content}, _, {:mid, series, rate}), do: {:mid, series, %{rate | mid: Decimal.new(to_string(content))}}
  defp handle_xml_event({:endElement, [], 'Mid', _}, _, {:mid, series, rate}), do: {:rate, series, rate}

  defp handle_xml_event({:endElement, [], 'Rate', _}, _, {:rate, series, rate}), do: {:rates, %{series | rates: [rate|series.rates]}}

  defp handle_xml_event({:endElement, [], 'Rates', _}, _, {:rates, series}), do: {:root, %{series | rates: Enum.reverse(series.rates)}}

  defp handle_xml_event({:endElement, [], 'ExchangeRatesSeries', _}, _, {:root, series}), do: {nil, series}
  defp handle_xml_event(:endDocument, _, {nil, series}), do: {nil, series}

  defp handle_xml_event(_event, _location, state), do: state
end
