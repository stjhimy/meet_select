defmodule MeetSelect.Params do
  @headers [{"Content-Type", "application/json"}]
  @options [recv_timeout: :infinity]

  def type_for_params(params) do
    params
    |> Enum.map(fn {name, {type, _}} ->
      {name, type_for_param(type)}
    end)
  end

  defp type_for_param(:string), do: quote(do: String.t())
  defp type_for_param(type), do: Code.string_to_quoted!(type)

  def validate_params(params, params_def) do
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

  def params_for_httpoison(:post, url, params) do
    [
      url,
      Poison.encode!(Map.new(params)),
      @headers,
      @options
    ]
  end

  def params_for_httpoison(:get, url, params) do
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
end