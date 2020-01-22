open Brr

let () =
  App.run (fun () ->
      let hello_world = El.p [ `Txt (Jstr.v "Hello World!") ] in
      El.set_children (El.document_body ()) [ hello_world ])
