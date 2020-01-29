open React

type direction = Up | Down | Left | Right

type action = Move of float * direction | Noop

type model = { side : float; position : float * float }

let side { side; _ } = side

let position { position; _ } = position

let initial = { side = 100.; position = (1., 1.) }

let update = function
  | Noop -> fun x -> x
  | Move (n, d) ->
      fun ({ position = x, y; _ } as m) ->
        let x, y =
          match d with
          | Up -> (x, y -. n)
          | Down -> (x, y +. n)
          | Left -> (x -. n, y)
          | Right -> (x +. n, y)
        in
        { m with position = (x, y) }

let add_keydown_listener send_a =
  let keydown ev =
    ( match ev##.keyCode with
    | 37 -> send_a (Move (1., Left))
    | 38 -> send_a (Move (1., Up))
    | 39 -> send_a (Move (1., Right))
    | 40 -> send_a (Move (1., Down))
    | _ -> send_a Noop );
    Js_of_ocaml.Js._true
  in
  let open Js_of_ocaml in
  let module Html = Dom_html in
  Html.addEventListener Html.document Html.Event.keydown (Html.handler keydown)
    Js._true

let view initial =
  let action, send_a = E.create () in
  let _ = add_keydown_listener send_a in
  let m = S.accum (E.map (fun a -> update a) action) initial in
  let square =
    let open Js_of_ocaml_tyxml.Tyxml_js in
    let module R = Js_of_ocaml_tyxml.Tyxml_js.R in
    let position = S.map position m in
    let side = S.map side m in
    let x_ = S.map fst position in
    let y_ = S.map snd position in
    [
      Svg.rect
        ~a:
          [
            R.Svg.a_x (S.map (fun x -> (x, Some `Px)) x_);
            R.Svg.a_y (S.map (fun x -> (x, Some `Px)) y_);
            R.Svg.a_height (S.map (fun x -> (x, Some `Px)) side);
            R.Svg.a_width (S.map (fun x -> (x, Some `Px)) side);
          ]
        [];
    ]
  in
  Js_of_ocaml_tyxml.Tyxml_js.Html.(
    div
      [
        svg
          ~a:
            [
              Js_of_ocaml_tyxml.Tyxml_js.Svg.a_width (100., Some `Percent);
              Js_of_ocaml_tyxml.Tyxml_js.Svg.a_height (100., Some `Percent);
            ]
          square;
      ])

let () = Js_of_ocaml_tyxml.Tyxml_js.Register.body [ view initial ]
