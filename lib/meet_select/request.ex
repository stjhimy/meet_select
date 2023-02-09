defmodule MeetSelect.Request do
  use HTTPoison.Base

  @base_url "https://www.meetselect.com/"
  @api_version "v2"

  def process_request_url(url) do
    @base_url <> "/api/" <> @api_version <> url
  end

  def process_response_body(body) do
    body
    |> Poison.decode!()
  end
end
