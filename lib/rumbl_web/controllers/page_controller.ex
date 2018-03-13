defmodule RumblWeb.PageController do
  use RumblWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def proxy(conn, _params) do
    search = String.replace(conn.request_path, "proxy/", "")
    query_str = if conn.query_string !== "", do: "?" <> conn.query_string, else: ""
    req_url = "http://localhost:8981" <> search <> query_str

    response = HTTPoison.get!(req_url)
    body = Poison.decode!(response.body)

    json(conn, body)
  end

#  def options_proxy(conn, _params) do
#    IO.puts(conn.host)
#    conn
#    |> put_resp_header("Access-Control-Allow-Credentials", "true")
#    |> put_resp_header("Access-Control-Allow-Headers", "User-Agent, Keep-Alive, Content-Type, Authorization, Cache")
#    |> put_resp_header("Access-Control-Allow-Methods", "GET, POST, OPTIONS, DELETE, PUT")
#    |> put_resp_header("Access-Control-Allow-Origin", "https://localhost:8082")
#    |> send_resp(204, "")
#  end

end
