open Note
open Brr

module Model = struct
  type t = { message : string }

  let initial = { message = "Navigation Demo" }
end

module Action = struct
  type page =
    | Bears
    | Cats of int
    | Dog of string
    | Fish
    | Elephants
    | No_match

  type t = Navigation of page

  let apply_navigation page model =
    match page with
    | Bears -> { Model.message = "I see some bears" }
    | Cats n -> { message = Printf.sprintf "I see %d cats" n }
    | Dog name -> { message = Printf.sprintf "This dog's name is %s" name }
    | Fish -> { message = "Fish" }
    | Elephants -> { message = "Elephant" }
    | No_match -> { message = "Page not found" }

  let update action model =
    match action with Navigation page -> apply_navigation page model
end

module Router = struct
  open Routes

  let bear () = s "bears" /? nil

  let cats () = s "cats" / int /? nil

  let dog () = s "dog" / str /? nil

  let fish () = s "fish" /? nil

  let elephants () = s "elephants" /? nil

  let router =
    one_of
      [
        (None, bear () @--> Action.Bears);
        (None, cats () @--> fun n -> Action.Cats n);
        (None, dog () @--> fun name -> Action.Dog name);
        (None, fish () @--> Action.Fish);
        (None, elephants () @--> Action.Elephants);
      ]

  let setup_router () =
    E.map
      (fun l ->
        Log.info (fun m -> m "Location is %s" (Jstr.to_string l));
        let target = Jstr.to_string l in
        let target =
          match target with
          | "" -> target
          | _ when target.[0] = '#' ->
              String.sub target 1 (String.length target - 1)
          | _ -> target
        in
        Option.value ~default:Action.No_match (match' ~target router))
      Loc.hashchange
end

let view model =
  S.map (fun { Model.message } -> [ El.span [ `Txt (Jstr.v message) ] ]) model

let main () =
  let route_actions =
    E.map
      (fun p -> Action.update (Action.Navigation p))
      (Router.setup_router ())
  in
  let model = S.accum Model.initial route_actions in
  let view = view model in
  let links =
    List.map
      (fun m ->
        let url = Jstr.v ("http://localhost:8000/#/" ^ m) in
        El.li [ El.a ~atts:[ Att.href url ] [ `Txt (Jstr.v m) ] ])
      [ "bears"; "fish"; "elephants"; "cats/12"; "dog/tupper" ]
  in
  let d = El.div [] in
  El.def_children d view;
  [ El.ul links; d ]

let () = App.run (fun () -> El.set_children (El.document_body ()) (main ()))
