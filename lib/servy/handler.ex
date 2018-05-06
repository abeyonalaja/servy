defmodule Servy.Handler do

  def handle(request) do

    request
    |> parse
    |> rewrite_path
    |> log
    |> route
    |> track
    |> format_response

  end

  def track(%{ status: 404, path: path } = conv) do
    IO.puts "Warning: #{path} is on the loose"
    conv
  end

  def track(conv), do: conv

  def rewrite_path(%{ path: "/wildlife" } = conv) do
    %{ conv | path: "/wildthings" }
  end

  def rewrite_path(conv), do: conv

  def log(conv), do: IO.inspect conv

  def parse(request) do
    [ method, path, _ ] =
      request
      |> String.split("\n")
      |> List.first
      |> String.split(" ")

    %{ method: method,
       path: path,
       resp_body: "",
       status: nil
    }
  end

  def route(conv) do
    route(conv, conv.method, conv.path)
  end

  def route(%{ method: "GET", path:"/wildthings" } = conv) do
    %{ conv | status: 200, resp_body: "Bears, Lions, Tigers" }
  end

  def route(%{ method: "GET", path:"/bears" } = conv) do
    %{ conv | status: 200, resp_body: "Teaddy, Smokey, Paddington" }
  end

  def route(%{ method: "GET", path:"/bears" <> id } = conv) do
    %{ conv | status: 200, resp_body: "Bear #{id}" }
  end

  def route(%{ path:"/bears" } = conv) do
    %{ conv | status: 404, resp_body: "No #{path} here!" }
  end

  def format_response(conv) do
     """
    HTTP/1.1 #{conv.status} #{status_response( conv.status )}
    Content-Type: text/html
    Content-Length: #{ String.length( conv.resp_body ) }

    #{ conv.resp_body }
    """
  end

  defp status_response(code) do
    %{
      200 => "OK",
      201 => "Created",
      401 => "Unauthorized",
      403 => "Forbidden",
      404 => "Not Found",
      500 => "Internal Server Error"
    }[code]
  end

end
request = """
GET /wildthings HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*
test
"""

response = Servy.Handler.handle(request)

IO.puts response

request = """
GET /bears/2 HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

    """

response = Servy.Handler.handle(request)

IO.puts response
