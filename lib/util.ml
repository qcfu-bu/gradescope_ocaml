
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

let list_of_string s =
  List.of_seq (String.to_seq s)

let filter_ws s =
  List.filter (fun c -> not (String.contains " \r\n\t\012" c)) s