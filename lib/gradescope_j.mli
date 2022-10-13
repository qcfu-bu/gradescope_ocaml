(* Auto-generated from "gradescope.atd" *)
[@@@ocaml.warning "-27-32-33-35-39"]

type result = Gradescope_t.result = {
  score: float option;
  max_score: float option;
  name: string option;
  number: string option;
  output: string option;
  visibility: string option
}

type gradescope = Gradescope_t.gradescope = {
  score: float option;
  execution_time: float option;
  output: string option;
  visibility: string option;
  stdout_visibility: string option;
  tests: result list option
}

val write_result :
  Buffer.t -> result -> unit
  (** Output a JSON value of type {!type:result}. *)

val string_of_result :
  ?len:int -> result -> string
  (** Serialize a value of type {!type:result}
      into a JSON string.
      @param len specifies the initial length
                 of the buffer used internally.
                 Default: 1024. *)

val read_result :
  Yojson.Safe.lexer_state -> Lexing.lexbuf -> result
  (** Input JSON data of type {!type:result}. *)

val result_of_string :
  string -> result
  (** Deserialize JSON data of type {!type:result}. *)

val write_gradescope :
  Buffer.t -> gradescope -> unit
  (** Output a JSON value of type {!type:gradescope}. *)

val string_of_gradescope :
  ?len:int -> gradescope -> string
  (** Serialize a value of type {!type:gradescope}
      into a JSON string.
      @param len specifies the initial length
                 of the buffer used internally.
                 Default: 1024. *)

val read_gradescope :
  Yojson.Safe.lexer_state -> Lexing.lexbuf -> gradescope
  (** Input JSON data of type {!type:gradescope}. *)

val gradescope_of_string :
  string -> gradescope
  (** Deserialize JSON data of type {!type:gradescope}. *)

