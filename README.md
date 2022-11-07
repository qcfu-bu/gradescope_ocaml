# BU CS320 Gradescope Bindings for OCaml

## Dependencies

* opam
* dune
* atdgen
* ounit2
* qcheck

Install dependencies with `opam install --deps-only .`

## Usage

Annotate ounit tests with labels `@` ^ `ANNO`. If `ANNO` can be parsed into a floating point number, then it will be used as the weight for the test, otherwise it will be used to control test visibility.

Example:

``` ocaml
open Gradescope    (* gradscope bindings *)
open OUnit         (* ocaml unit testing *)
open Sum           (* student submission *)

(* reference implementation *)
let rec sum = function
  | []    -> 0
  | x::xs -> x + sum xs

(* testing sum of nats *)
let test1 =
  Gradescope.to_ounit_test
    (QCheck.Test.make ~count:1000 ~name:"small_nat"
       QCheck.(list small_nat)
       (fun l -> (Sum.sum l) = sum l))

(* testing sum of ints *)
let test2 =
  Gradescope.to_ounit_test
    (QCheck.Test.make ~count:1000 ~name:"small_int"
       QCheck.(list small_int)
       (fun l -> (Sum.sum l) = sum l))

(* testing sum of nats reversed *)
let test3 =
  Gradescope.to_ounit_test
    (QCheck.Test.make ~count:1000 ~name:"rev small_nat"
       QCheck.(list small_nat)
       (fun l -> (Sum.sum (List.rev l) = sum l)))

(* testing sum of ints reversed *)
let test4 =
  Gradescope.to_ounit_test
    (QCheck.Test.make ~count:1000 ~name:"rev small_int"
       QCheck.(list small_int)
       (fun l -> (Sum.sum (List.rev l) = sum l)))

(* annotate tests with meta information *)
 let tests = "sum" >::: [
     "@25" >: ("@hidden"          >: test1);
     "@25" >: ("@after_due_date"  >: test2);
     "@25" >: ("@after_published" >: test3);
     "@25" >: ("@visible"         >: test4);
 ]

(* generate results.json *)
 let _ =
   run_gradescope
     ~enable_timer:(true)
     ~tests:(Some tests)
     (open_out Gradescope.result_path)
```


