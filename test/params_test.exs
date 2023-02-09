defmodule MeetSelect.ParamsTest do
  use ExUnit.Case

  test "keys_to_atom" do
    [
      {%{"key" => "v"}, [key: "v"]},
      {%{key: "v"}, [key: "v"]},
      {%{"key" => "v", key2: "v"}, [key: "v", key2: "v"]},
      {[key: "v", key2: "v"], [key: "v", key2: "v"]}
    ]
    |> Enum.each(&assert MeetSelect.Params.keys_to_atom(elem(&1, 0)) == elem(&1, 1))
  end
end
