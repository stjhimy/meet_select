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

  describe "authenticate" do
    test "required params" do
      assert_raise RuntimeError, "Missing required params: [:username, :password]", fn ->
        MeetSelect.authenticate([])
      end
    end

    test "request" do
      MeetSelect.authenticate(%{username: "foo", password: "bar"})

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
      assert_raise RuntimeError,
                   "Missing required params: [:check_in, :check_out, :rooms, :adults, :latitude, :longitude]",
                   fn ->
                     MeetSelect.search_hotels([])
                   end
    end

    test "request" do
      MeetSelect.search_hotels(%{
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
