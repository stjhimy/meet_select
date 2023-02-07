defmodule MeetSelect.Glossary do
  @api [
    authenticate: %{
      url: "/auth/api/token/",
      method: :post,
      doc: """
      Authenticate a given user with username and password.

      - Required keys: [:username, :password]
      - Optional keys: []

      ### Examples:
          iex> MeetSelect.authenticate(username: "foo", password: "bar")
          {401, %{detail: "No active account found with the given credentials"}}

          iex> MeetSelect.authenticate(username: "foo", password: "bar")
          {200, %{refresh: "refresh", access: "access", user: %{}}}

      The value returned under `access` is the current user token and should be used
      in subsequent authenticated requests.
      """,
      params: [
        username: {:string, :required},
        password: {:string, :required}
      ]
    },
    search_hotels: %{
      url: "/hotel/search/list/",
      method: :get,
      doc: """
      List available hotels/rooms for a specific location based on latitude and longitude.

      - Required keys: [:check_in, :check_out, :rooms, :adults, :latitude, :longitude]
      - Optional keys: []

      ### Examples:
          iex> MeetSelect.list_hotels(check_in: "", check_out: "")
          {200, %{}}
      """,
      params: [
        check_in: {:string, :required},
        check_out: {:string, :required},
        rooms: {:integer, :required},
        adults: {:integer, :required},
        latitude: {:string, :required},
        longitude: {:string, :required}
      ]
    }
    # search_hotel_details: %{
    #   url: "/hotel/search/detail/",
    #   method: :get,
    #   docs: "",
    #   params: [
    #     hotel_id: {:integer, :required},
    #     rooms: {:integer, :required},
    #     check_in: {:string, :required},
    #     check_out: {:string, :required}
    #   ]
    # },
    # search_locations: %{
    #   url: "/hotel/location/",
    #   method: :get,
    #   docs: "",
    #   params: [
    #     search: {:string, :required}
    #   ]
    # },
    # get_hotel_details: %{
    #   url: "/hotel/:id/detail/",
    #   method: :get,
    #   docs: "",
    #   params: [
    #     id: {:string, :required}
    #   ]
    # },
    # get_hotel_reviews: %{
    #   url: "/hotel/:id/review/",
    #   method: :get,
    #   docs: "",
    #   params: [
    #     id: {:string, :required}
    #   ]
    # }
  ]

  @spec glossary() :: any()
  def glossary() do
    @api
  end
end
