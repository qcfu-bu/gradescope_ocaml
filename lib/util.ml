
let read_lines ic =
  let rec loop acc =
    try loop (String.trim (input_line ic) :: acc)
    with End_of_file -> List.rev acc
  in loop []

let rec write_lines ls oc = match ls with
  | s :: ls ->
   Printf.fprintf oc "%s\n" s;
   write_lines ls oc
  | [] -> ()
