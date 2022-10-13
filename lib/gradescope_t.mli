(* Auto-generated from "gradescope.atd" *)
[@@@ocaml.warning "-27-32-33-35-39"]

type result = {
  score: float option;
  max_score: float option;
  name: string option;
  number: string option;
  output: string option;
  visibility: string option
}

type gradescope = {
  score: float option;
  execution_time: float option;
  output: string option;
  visibility: string option;
  stdout_visibility: string option;
  tests: result list option
}
