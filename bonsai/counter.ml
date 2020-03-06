open Core_kernel
open Bonsai_web

module Model = struct
  type t = int
end

module CounterComponent = struct
  module Input = Unit
  module Result = Vdom.Node
  module Model = Model

  module Action = struct
    type t = Increment | Decrement [@@deriving sexp]
  end

  let apply_action ~inject:_ ~schedule_event:_ () model = function
    | Action.Increment -> model + 1
    | Decrement -> model - 1

  let compute ~inject () model =
    let on_click act = Vdom.Attr.on_click (fun _ -> inject act) in
    Vdom.Node.div []
      [
        Vdom.Node.button [ on_click Action.Decrement ] [ Vdom.Node.text "-" ];
        Vdom.Node.text (Int.to_string model);
        Vdom.Node.button [ on_click Action.Increment ] [ Vdom.Node.text "+" ];
      ]

  let name = Source_code_position.to_string [%here]
end

let counter_component = Bonsai.of_module (module CounterComponent)

let (_ : _ Start.Handle.t) =
  Start.start_standalone ~initial_input:() ~initial_model:0
    ~bind_to_element_with_id:"app" counter_component
