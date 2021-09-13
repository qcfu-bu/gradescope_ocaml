

(* initialize gradescope testing *)
val run_gradescope :
  ?score:(float option) ->
  ?enable_timer:(bool) ->
  ?output:(string option) ->
  ?visibility:(string option) ->
  ?stdout_visibility:(string option) ->
  ?tests:(OUnit.test option) ->
  out_channel -> unit


(* wrapper for qcheck *)
val to_ounit_test :
  ?verbose:bool ->
  ?long:bool ->
  ?rand:(Stdlib.Random.State.t) ->
  (QCheck2.Test.t) -> OUnit.test


(* path to write to *)
val result_path : string
