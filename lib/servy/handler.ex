defmodule Servy.Handler do

  def handle(request) do

    request
    |> parse
    |> route
    |> format_response

  end

  def parse(request) do
    #TODO: Parse the request string into a map:
    conv = %{ method: "GET", path: "/wildthings", resp_body: "" }
  end

  def route(cov) do
    # TODO: create a new map that also has the response body
    conv = %{ method: "GET", path: "/wildthings", resp_body: "Bears, Lions, Tigers" }
  end

  def format_response(cov) do
     """
    HTTP/1.1 200 OK
    Content-Type: text/html
    Content-Length: 20

    Bears, Lions, Tigers
    """
  end
end

request = """
GET /wildthings HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)

IO.puts response
