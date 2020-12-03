open Debug_protocol

type t
(** The type of rpc connection *)

val create : in_:Lwt_io.input_channel -> out:Lwt_io.output_channel -> ?next_seq:int -> unit -> t
(** [create ~in_ ~out ?next_seq ()] Create a rpc session *)

val event : t -> (module EVENT with type Body.t = 'a) -> 'a React.E.t
(** [event rpc (module The_event)] Get a [The_event.Body.t React.E.t] for opposite end sent events *)

val send_event : t -> (module EVENT with type Body.t = 'a) -> 'a -> unit Lwt.t
(** [send_event rpc (module The_event) body] Send event with [body] to the opposite end *)

val register_command : t -> (module COMMAND with type Request.Arguments.t = 'a and type Response.Body.t = 'b) -> (t -> 'a -> string -> 'b Lwt.t) -> unit
(** [register_command rpc (module The_command) f] Register command handler [f] for [The_command] *)

val exec_command : t -> (module COMMAND with type Request.Arguments.t = 'a and type Response.Body.t = 'b) -> 'a -> 'b Lwt.t
(** [exec_command rpc (module The_command) arg] Execute [The_command] with [arg] on the opposite end.
  @return [res] Returns promise of [The_command.Response.Body.t]. You can use [Lwt.cancel] on it to cancel the request. *)

val start : t -> unit Lwt.t
(** [start rpc] Start rpc dispatch loop. You must call it before interact with rpc. This method will block until input_channel closed. You may call it in a [Lwt.async] block  *)
