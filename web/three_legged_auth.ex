# File: three_legged_auth.ex
# Purpose: Require login from the Learn server before getting the access_token
# Author: Mark Bykerk Kauffman

defmodule ThreeLeggedAuth do
  import Plug.Conn
  require Logger

  @realm "Basic realm=\"phoenixDSK3LO\""

  def init(opts), do: opts

  def call(conn, [fqdn: fqdn]) do
    # Plug protocol is that the Plug always returns the conn (connection).
    IO.puts :stdio, "ENTER ThreeLeggedAuth.call"
    IO.inspect(fqdn)
    token_map = LearnRestClient.get(String.to_atom(fqdn), "tokenMap")
    IO.inspect(token_map)
    threelo_code = LearnRestClient.get(String.to_atom(fqdn),"THREELO_CODE")
    IO.inspect(threelo_code)

    case (threelo_code) do
      nil -> get_code(conn, fqdn)
      _ -> conn
    end
    IO.puts :stdio, "EXIT ThreeLeggedAuth.call"
    conn
  end

  # First leg of three_legged_oauth - login to get a code.
  # The code is then used to get an access token.
  def get_code(conn, fqdn) do
    IO.puts :stdio, "ENTER ThreeLeggedAuth.get_code"
    app_key = Application.get_env(:phoenixDSK3LO, PhoenixDSK3LO.Endpoint)[:appkey]

    %{req_headers: req_headers } = conn
    IO.puts :stdio, "*********** CONN ************"
    IO.inspect conn, []
    headers_map = Enum.into req_headers, %{} # turn the list of tuples into a map
    host = headers_map["host"]
    x_forwarded_proto = headers_map["x-forwarded-proto"]
    case x_forwarded_proto do
      "https" -> redirect_uri = "https://#{host}/code_callback"
      _ -> redirect_uri = "http://#{host}/code_callback"
    end

    fqdn = Application.get_env(:phoenixDSK3LO, PhoenixDSK3LO.Endpoint)[:learnserver]
    fqdnAtom = String.to_atom(fqdn)
    # save our redirect_uri for use when we get the access_token
    LearnRestClient.put(fqdnAtom, "REDIRECT_URI", redirect_uri)
    redirect_url = "redirect_uri=#{redirect_uri}&response_type=code&client_id=#{app_key}&scope=read%20write%20offline"
    IO.inspect redirect_uri, []
    options = [ domain: "localhost", path: "/", max_age: 100000*24*60*60]
    IO.inspect options, []


    authcode_url = LearnRestClient.get_authcode_url(fqdn)
    authcode_url = authcode_url <> "?#{redirect_url}"
    conn = conn
    |> put_resp_header("location", authcode_url)
    |> put_resp_cookie("A_COOKIE", "chocolate_chip", options)
    IO.inspect conn, []
#    send_resp(conn, 200, "Hello world") # playing around with cookies here.
    send_resp(conn, 303, "")
    |> halt
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
