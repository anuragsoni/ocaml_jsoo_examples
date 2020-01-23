open React

type model = int

let initial_model = 0

type action = Increment | Decrement

let update = function
  | Increment -> fun x -> x + 1
  | Decrement -> fun x -> x - 1

let create_button action send m =
  let open Js_of_ocaml_tyxml.Tyxml_js.Html in
  button
    ~a:
      [
        a_onclick (fun _ ->
            send action;
            true);
      ]
    [ txt m ]

let update_message send =
  let open Lwt.Infix in
  let rec loop () =
    Js_of_ocaml_lwt.Lwt_js.sleep 1.0 >>= fun () ->
    send (fun x -> x + 1);
    loop ()
  in
  Lwt.async loop

let view () =
  let action, send_a = E.create () in
  let timer, send_timer = E.create () in
  update_message send_timer;
  let timer' = S.accum timer 0 in
  let add_btn = create_button Increment send_a "+" in
  let sub_btn = create_button Decrement send_a "-" in
  let count = S.accum (E.map (fun a -> update a) action) initial_model in
  let open Js_of_ocaml_tyxml.Tyxml_js.Html in
  let module R = Js_of_ocaml_tyxml.Tyxml_js.R.Html in
  let timer_node = span [ R.txt (S.map string_of_int timer') ] in
  let c = span [ R.txt (S.map string_of_int count) ] in
  div [ timer_node; sub_btn; c; add_btn ]

let () = Js_of_ocaml_tyxml.Tyxml_js.Register.body [ view () ]
