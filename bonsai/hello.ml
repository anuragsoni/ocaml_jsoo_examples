open Bonsai_web

let component = Bonsai.const (Vdom.Node.text "Hello World")

let (_ : _ Start.Handle.t) =
  Start.start_standalone ~initial_input:() ~initial_model:()
    ~bind_to_element_with_id:"app" component
