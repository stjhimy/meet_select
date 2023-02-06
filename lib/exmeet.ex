defmodule Exmeet do
  use HTTPoison.Base

  @base_url "https://kirk.meetselect.com"
  @api_version "v2"
  @headers [{"Content-Type", "application/json"}]
  @options [recv_timeout: :infinity]

  @api %{
    authenticate: %{
      url: "/auth/api/token/",
      method: :post,
      params: [
        username: {:string, :required},
        password: {:string, :required}
      ]
    },
    search_hotels: %{
      url: "/hotel/search/list/",
      method: :get,
      params: [
        check_in: {:string, :required},
        check_out: {:string, :required},
        rooms: {:integer, :required},
        adults: {:integer, :required},
        latitude: {:string, :required},
        longitude: {:string, :required}
      ]
    },
    search_hotel_details: %{
      url: "/hotel/search/detail/",
      method: :get,
      params: [
        hotel_id: {:integer, :required},
        rooms: {:integer, :required},
        check_in: {:string, :required},
        check_out: {:string, :required}
      ]
    },
    search_locations: %{
      url: "/hotel/location/",
      method: :get,
      params: [
        search: {:string, :required}
      ]
    },
    get_hotel_details: %{
      url: "/hotel/:id/detail/",
      method: :get,
      params: [
        id: {:string, :required}
      ]
    },
    get_hotel_reviews: %{
      url: "/hotel/:id/review/",
      method: :get,
      params: [
        id: {:string, :required}
      ]
    }
  }

  @api
  |> Enum.each(fn {name, details} ->
    def unquote(name)(params) do
      validate_params(params, unquote(details.params))

      apply(
        __MODULE__,
        unquote(details.method),
        params_for_httpoison(unquote(details.method), unquote(details.url), params)
      )
    end
  end)

  defp params_for_httpoison(:post, url, params) do
    [
      url,
      Poison.encode!(Map.new(params)),
      @headers,
      @options
    ]
  end

  defp params_for_httpoison(:get, url, params) do
    [
      evaluate_url_params(url, params),
      @headers,
      @options ++ [params: params]
    ]
  end

  defp evaluate_url_params(url, params) do
    regex = ~r/(?<name>:[^\/]+)/

    named_params =
      Regex.scan(regex, url)
      |> List.flatten()
      |> Enum.uniq()

    Enum.reduce(named_params, url, fn item, acc ->
      String.replace(
        acc,
        item,
        Keyword.get(params, String.to_atom(String.replace(item, ":", ""))) |> to_string()
      )
    end)
  end

  defp validate_params(params, params_def) do
    case filter_required_params(params_def) -- Enum.map(params, &elem(&1, 0)) do
      [] -> true
      missing -> raise("Missing required params: #{inspect(missing)}")
    end
  end

  defp filter_required_params(params) do
    params
    |> Enum.filter(&({_, {_, :required}} = &1))
    |> Enum.map(fn {name, _} -> name end)
  end

  def process_request_url(url) do
    @base_url <> "/api/" <> @api_version <> url
  end
end
