defmodule MeetSelect.Macros do
  alias MeetSelect.{Glossary, Params, Request}

  defmacro __using__(_opts) do
    Glossary.glossary()
    |> Enum.map(fn {name, details} ->
      quote do
        @doc unquote(details.doc)
        @spec unquote(name)(Params.type_for_params(unquote(details.params))) ::
                {:ok, %HTTPoison.Response{}} | {:error, any()}
        def unquote(name)(params) do
          params = Params.keys_to_atom(params)

          with :ok <- Params.validate_params(params, unquote(details.params)) do
            apply(
              Request,
              unquote(details.method),
              Params.params_for_httpoison(
                unquote(details.method),
                unquote(details.url),
                params
              )
            )
          else
            {:error, _} = message -> message
          end
        end
      end
    end)
  end
end
