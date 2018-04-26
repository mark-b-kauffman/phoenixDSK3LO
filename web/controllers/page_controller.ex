defmodule PhoenixDSK3LO.PageController do
  use PhoenixDSK3LO.Web, :controller
  
  def index(conn, _params) do
    render conn, "index.html"
  end
end
