open Vdom

type model = int

type action = Increment | Decrement

let update x = function Increment -> x + 1 | Decrement -> x - 1

let init = 0

let button txt action =
  input [] ~a:[ onclick (fun _ -> action); type_button; value txt ]

let view model =
  div [ button "-" Decrement; text (string_of_int model); button "+" Increment ]

let app = simple_app ~init ~view ~update ()

open Js_browser

let run () =
  Vdom_blit.run app |> Vdom_blit.dom
  |> Element.append_child (Document.body document)

let () = Window.set_onload window run
