defmodule MeetSelect.Glossary do
  @api [
    auth_api_token: %{
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
    hotel_search_list: %{
      url: "/hotel/search/list/",
      method: :get,
      doc: """
      List available hotels/rooms for a specific location based on latitude and longitude.

      - Required keys: [:check_in, :check_out, :rooms, :adults, :latitude, :longitude]
      - Optional keys: []

      ### Examples:
          iex> params = [
                check_in: "2023-12-01",
                check_out: "2023-12-02",
                rooms: 1,
                adults: 1,
                lat: "",
                long: ""
          ]
          iex> MeetSelect.list_hotels(params)
          {200, [%{id: "foo", name: "bar"}]}
      """,
      params: [
        check_in: {:string, :required},
        check_out: {:string, :required},
        rooms: {:integer, :required},
        adults: {:integer, :required},
        latitude: {:string, :required},
        longitude: {:string, :required}
      ]
    },
    hotel_search_detail: %{
      url: "/hotel/search/detail/",
      method: :get,
      doc: """
      Get details for a specific hotel.

      - Required keys: [:hotel_id, :check_in, :check_out, :rooms]
      - Optional keys: []

      ### Examples
          iex> MeetSelect.hotel_search_detail(hotel_id: "hotel_id", check_in: "2023-12-01", check_out: "2023-12-02", rooms: 1)
          {200, %{}}
      """,
      params: [
        hotel_id: {:integer, :required},
        rooms: {:integer, :required},
        check_in: {:string, :required},
        check_out: {:string, :required}
      ]
    },
    hotel_location: %{
      url: "/hotel/location/",
      method: :get,
      doc: """
      Retrieve hotel locations.

      - Required keys: [:search]
      - Optional keys: []

      ### Examples
          iex> MeetSelect.hotel_location(search: "usa")
          {200, %{}}
      """,
      params: [
        search: {:string, :required}
      ]
    },
    hotel_detail: %{
      url: "/hotel/:id/detail/",
      method: :get,
      doc: """
      Get details for a specific hotel.

      - Required keys: [id]
      - Optional keys: []

      ### Examples
          iex> MeetSelect.hotel_details(id: "hotel_id")
          {200, %{}}
      """,
      params: [
        id: {:string, :required}
      ]
    },
    hotel_review: %{
      url: "/hotel/:id/review/",
      method: :get,
      doc: """
      Get reviews for a specific hotel.

      - Required keys: [id]
      - Optional keys: []

      ### Examples
          iex> MeetSelect.hotel_review(id: "hotel_id")
          {200, %{}}
      """,
      params: [
        id: {:string, :required}
      ]
    }
  ]

  @spec glossary() :: any()
  def glossary() do
    @api
  end
end
