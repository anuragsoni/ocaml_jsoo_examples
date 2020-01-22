open Note
open Brr

type model = int

let initial_model = 0

let apply_action = function
  | `Increment -> fun x -> x + 1
  | `Decrement -> fun x -> x - 1

let create_button action label =
  let btn = El.button [ `Txt (Jstr.v label) ] in
  let e = Ev.for_el btn Ev.click (fun _ -> apply_action action) in
  (btn, e)

let main () =
  let add, add_ev = create_button `Increment "+" in
  let dec, dec_ev = create_button `Decrement "-" in
  let events = E.select [ add_ev; dec_ev ] in
  let counter_s = S.accum 0 events in
  S.map
    (fun model -> [ dec; `Txt (Jstr.v (string_of_int model)); add ])
    counter_s

let () = App.run (fun () -> El.def_children (El.document_body ()) (main ()))
