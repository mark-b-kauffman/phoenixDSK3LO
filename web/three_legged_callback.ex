# File: three_legged_auth.ex
# Purpose: We come back here after the 3LO login. Save off the authorization code,
#   then immediatly make a request for dsks that takes us through the code that
#   gets an access_token.
# Author: Mark Bykerk Kauffman

defmodule PhoenixDSK3LO.ThreeLeggedCallback do
  import Plug.Conn
  require Logger

  @realm "Basic realm=\"phoenixDSK3LO\""

  def init(opts), do: opts

  def call(conn, _opts) do
    IO.puts :stdio, "ENTER ThreeLeggedCallback.call"
    %{params: params} = conn
    %{"code" => code} = params
    IO.inspect params, []
    IO.inspect code, []
    fqdn = Application.get_env(:phoenixDSK3LO, PhoenixDSK3LO.Endpoint)[:learnserver]
    fqdnAtom = String.to_atom(fqdn)
    LearnRestClient.put(fqdnAtom, "THREELO_CODE", code)
    conn
    |> put_resp_header("location", "/dsks")
    |> send_resp(301, "")
    |> halt
    # Can't add any lines here because that confuses the framework and we get
    # exceptions like:
    # (Plug.Conn.NotSentError) a response was neither set nor sent from the connection
  end

  defp verify(conn, attempted_auth, [username: username, password: password]) do
    case encode(username, password) do
      ^attempted_auth -> conn
      _               -> unauthorized(conn)
    end
  end

  defp encode(username, password), do: Base.encode64(username <> ":" <> password)

  defp unauthorized(conn) do
    conn
    |> put_resp_header("www-authenticate", @realm)
    |> send_resp(401, "unauthorized")
    |> halt()
  end
end
