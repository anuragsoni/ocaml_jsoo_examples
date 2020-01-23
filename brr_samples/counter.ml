open Note
open Brr

type model = int

let initial_model = 0

type action = Increment | Decrement

let apply_action = function
  | Increment -> fun x -> x + 1
  | Decrement -> fun x -> x - 1

let create_button : action -> string -> El.child * action Note.event =
 fun action label ->
  let btn = El.button [ `Txt (Jstr.v label) ] in
  let e = Ev.for_el btn Ev.click (fun _ -> action) in
  (btn, e)

let timer send () =
  let open Lwt.Infix in
  let rec loop () =
    Js_of_ocaml_lwt.Lwt_js.sleep 1. >>= fun () ->
    send (fun x -> x + 1);
    loop ()
  in
  Lwt.async loop

(** We need to re-create the elements that are affected by the model change *)
let count : model Note.signal -> El.child list Note.signal =
 fun m -> S.map (fun c -> [ `Txt (Jstr.v (string_of_int c)) ]) m

let main : unit -> El.child list =
 fun () ->
  let sub, sub_e = create_button Decrement "-" in
  let add, add_e = create_button Increment "+" in
  let t, send_t = E.create () in
  timer send_t ();
  let timer_content = S.accum 0 t in
  let t' = El.span [] in
  El.def_children t'
    (S.map (fun x -> [ `Txt (Jstr.v (string_of_int x)) ]) timer_content);
  (* [events] will track the occurrence of every Increment/Decrement event  *)
  let events = E.select [ sub_e; add_e ] in
  let do_action = E.map apply_action events in
  (* We will start accumulating the counter value, starting with our initial_model state *)
  let counts = S.accum initial_model do_action in
  let count = count counts in
  let p = El.span [] in
  El.def_children p count;
  [ t'; sub; p; add ]

let () = App.run (fun () -> El.set_children (El.document_body ()) (main ()))
