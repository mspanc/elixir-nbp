defmodule NBP.Request do
  @moduledoc """
  Module responsible for wrapping logic of the HTTP requests
  issued to the NBP API.
  """

  alias NBP.Response

  @doc """
  Issues a GET request to the NBP API.

  On success it returns `{:ok, response}` where response is
  a `Response` struct.

  On error it returns either `{:error, {:http, reason}}` when
  underlying HTTP call has failed or `{:error, {:code, code, body}}`
  when the HTTP call suceeded but it returned unexpected status
  code.
  """
  @spec get(Tesla.Env.url(), [Tesla.option()]) ::
          {:ok, Response.t()}
          | {:error, {:http, any}}
          | {:error, {:code, pos_integer, any}}
  def get(path, opts \\ []) do
    client()
    |> Tesla.get(path, opts)
    |> make_response()
  end

  defp client() do
    Tesla.client([
      {Tesla.Middleware.BaseUrl,
       Application.get_env(:nbp, :base_url, "https://api.nbp.pl")},
      {Tesla.Middleware.Headers,
       [
         {"user-agent",
          Application.get_env(:nbp, :user_agent, default_user_agent!())},
         {"accept", "application/xml"},
       ]},
    ])
  end

  defp make_response(response) do
    case response do
      {:ok, %Tesla.Env{status: 200, body: body}} ->
        {:ok, %Response{body: body}}

      {:ok, %Tesla.Env{status: status, body: body}} ->
        {:error, {:code, status, body}}

      {:error, reason} ->
        {:error, {:http, reason}}
    end
  end

  defp default_user_agent! do
    lib_version =
      case :application.get_key(:nbp, :vsn) do
        {:ok, vsn} ->
          List.to_string(vsn)

        :undefined ->
          "dev"
      end

    "nbp #{lib_version} (Elixir #{System.version()})"
  end
end
