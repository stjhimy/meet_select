defmodule ExMeetSelectApi do
  use HTTPoison.Base
  alias ExMeetSelectApi.AuthToken

  # @base_url "http://www.meetselect.com"
  @base_url "https://kirk.meetselect.com"
  @api_version "v2"
  @headers [{"Content-Type", "application/json"}]

  ##############
  #### API #####
  ##############

  @spec authenticate(String.t(), String.t()) :: {:ok, AuthToken.t()} | {:error, any()}
  def authenticate(username, password) do
    post(
      "/auth/api/token/",
      %{username: username, password: password} |> Poison.encode!(),
      @headers
    )
    |> process_authenticate()
  end

  @spec search_hotels(keyword()) :: any()
  def search_hotels(params \\ []) do
    get(
      "/hotel/search/list/",
      @headers,
      params: params
    )
  end

  @spec search_locations(keyword()) :: any()
  def search_locations(params \\ []) do
    get(
      "/hotel/search/list/",
      @headers,
      params: params
    )
  end

  @spec get_hotel_details(keyword()) :: any()
  def get_hotel_details(params \\ []) do
    get(
      "/hotel/search/detail/",
      @headers,
      params: params
    )
  end

  ###################
  #### HTTPoison ####
  ###################

  def process_request_url(url) do
    (@base_url <> "/api/" <> @api_version <> url) |> IO.inspect()
  end

  #################
  #### Helpers ####
  #################

  defp process_authenticate({:ok, %{status_code: 200, body: body}}) do
    {:ok, decoded} = Poison.decode(body)
    {:ok, AuthToken.new(decoded["refresh"], decoded["access"], decoded["user"])}
  end

  defp process_authenticate({:ok, response}) do
    {:error, response}
  end
end
