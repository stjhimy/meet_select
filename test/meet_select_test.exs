defmodule MeetSelectTest do
  use ExUnit.Case

  import Mock

  alias MeetSelect.Request

  setup_with_mocks [
    {Request, [:passthrough], post: fn url, _, _, _ -> url end},
    {Request, [:passthrough], get: fn url, _, _ -> url end}
  ] do
    {:ok, []}
  end

  describe "api_aith_token" do
    test "required params" do
      assert {:error, _} = MeetSelect.auth_api_token([])
    end

    test "request" do
      MeetSelect.auth_api_token(%{username: "foo", password: "bar"})

      assert_called(
        Request.post(
          "/auth/api/token/",
          "{\"username\":\"foo\",\"password\":\"bar\"}",
          [{"Content-Type", "application/json"}],
          recv_timeout: :infinity
        )
      )
    end
  end

  describe "search_hotels" do
    test "required params" do
      assert {:error, _} = MeetSelect.hotel_search_list([])
    end

    test "request" do
      MeetSelect.hotel_search_list(%{
        check_in: "2023-01-01",
        check_out: "2023-01-02",
        rooms: 1,
        adults: 1,
        latitude: "lat",
        longitude: "long"
      })

      assert_called(
        Request.get("/hotel/search/list/", [{"Content-Type", "application/json"}],
          recv_timeout: :infinity,
          params: %{
            adults: 1,
            check_in: "2023-01-01",
            check_out: "2023-01-02",
            latitude: "lat",
            longitude: "long",
            rooms: 1
          }
        )
      )
    end
  end
end
