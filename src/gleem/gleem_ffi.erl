-module(gleem_ffi).
-export([cmd/1]).

cmd(String) ->
  os:cmd(binary_to_list(String)).