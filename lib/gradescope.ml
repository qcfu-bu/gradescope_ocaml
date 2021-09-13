open Gradescope_j
open OUnit
open OUnitUtils
open QCheck_base_runner
open Str


(* test `rev small_nat` failed on ≥ 1 cases: [2; 0] (after 14 shrink steps) *)
let fail_printer s ls =
  (Printf.sprintf "Counter example for `%s` found:\n" s) ^
  List.fold_left (fun a b -> a ^ "\n" ^ b) "" ls


(* wrapper for qcheck *)
let to_ounit_test_cell ?(verbose=verbose()) ?(long=long_tests())
    ?(rand=random_state()) cell =
  let module T = QCheck.Test in
  let name = T.get_name cell in
  let run () =
    try
      T.check_cell_exn cell ~long ~rand
        ~call:(fun s ->
            Raw.callback
              ~colors:false
              ~verbose
              ~print_res:verbose
              ~print:Raw.print_std s);
      (true, name)
    with T.Test_fail (s, ls) ->
      (false, fail_printer s ls)
  in
  name >:: (fun () ->
      let (result, msg) = run()
      in assert_bool msg result)


(* wrapper for qcheck *)
let to_ounit_test ?verbose ?long ?rand (QCheck2.Test.Test c) =
  to_ounit_test_cell ?verbose ?long ?rand c


(* parse ounit path for gradescope meta information *)
let anno = regexp "@\\(.*\\)"
let meta_of_path p =
  let rec aux p meta =
    let (nam, num, w, v) = meta in
    match p with
    | ListItem i :: p -> (
        match num with
        | Some _ -> aux p meta
        | None -> aux p (nam, Some (string_of_int (i + 1)), w, v)
      )
    | Label s :: p -> (
        if string_match anno s 0 then
          let s = matched_group 1 s in
          try
            let w' = Some (float_of_string s) in
            match w with
            | Some _ -> aux p meta
            | None -> aux p (nam, num, w', v)
          with _ ->
          match v with
          | Some _ -> aux p meta
          | None -> aux p (nam, num, w, Some s)
        else
          match nam with
          | Some _ -> aux p meta
          | None -> aux p (Some s, num, w, v)
      )
    | [] -> meta
  in aux p (None, None, None, None)


(* generate json-friendly records from ounit results *)
let test_result_to_result = function
  | RSuccess p ->
    let (nam, num, w, v) = meta_of_path p in
    {
      score= w;
      max_score= w;
      name= nam;
      number= num;
      output= Some "Success";
      visibility= v;
    }
  | RFailure (p, s) ->
    let (nam, num, w, v) = meta_of_path p in
    {
      score= Some 0.;
      max_score= w;
      name= nam;
      number= num;
      output= Some ("Failed with message:\n" ^ s);
      visibility= v;
    }
  | RError (p, s) ->
    let (nam, num, w, v) = meta_of_path p in
    {
      score= Some 0.;
      max_score= w;
      name= nam;
      number= num;
      output= Some ("Error with message:\n" ^ s);
      visibility= v;
    }
  | RSkip (p, s) ->
    let (nam, num, _, v) = meta_of_path p in
    {
      score= None;
      max_score= None;
      name= nam;
      number= num;
      output= Some ("Skipped with message:\n" ^ s);
      visibility= v;
    }
  | RTodo (p, s) ->
    let (nam, num, _, v) = meta_of_path p in
    {
      score= None;
      max_score= None;
      name= nam;
      number= num;
      output= Some ("Todo with message:\n" ^ s);
      visibility= v;
    }


(* initialize gradescope testing *)
let run_gradescope
    ?score:(score=None)
    ?enable_timer:(enable_timer=false)
    ?output:(output=None)
    ?visibility:(visibility=Some "visible")
    ?stdout_visibility:(stdout_visibility=Some "hidden")
    ?tests:(tests=None)
    oc
  =
  let (execution_time, tests) =
    match tests with
    | Some tests ->
      if enable_timer then
        let execution_time, test_results =
          time_fun (perform_test (fun _ -> ())) tests in
        let results = List.map test_result_to_result test_results in
        (Some execution_time, Some (List.rev results))
      else
        let test_results = perform_test (fun _ -> ()) tests in
        let results = List.map test_result_to_result test_results in
        (None, Some (List.rev results))
    | None -> (None, None)
  in
  let gradescope = {
    score= score;
    execution_time= execution_time;
    output= output;
    visibility= visibility;
    stdout_visibility= stdout_visibility;
    tests= tests;
  }
  in
  Printf.fprintf oc "%s\n"
    (Yojson.Safe.prettify
       (Gradescope_j.string_of_gradescope gradescope))


(* path to write to *)
let result_path = "/autograder/results/results.json"
