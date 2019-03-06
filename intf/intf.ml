module type S = sig
  type 'a t

  module Monad : sig
    type nonrec 'a t = 'a t
    val (>|=) : 'a t -> ('a -> 'b) -> 'b t
    val (>>=) : 'a t -> ('a -> 'b t) -> 'b t
    val return : 'a -> 'a t
  end

  module Body : sig
    type stream

    type t = [
      | Cohttp.Body.t
      | `Stream of stream
    ]

    val to_string : t -> string Monad.t

    val to_string_list : t -> string list Monad.t

    val empty : t

    val map : (string -> string) -> t -> t

    val transfer_encoding : t -> Cohttp.Transfer.encoding

    val is_empty : t -> bool Monad.t

    val of_string : string -> t

    val of_string_list : string list -> t

    val to_stream : t -> stream

    val of_stream : stream -> t

    val drain_body : t -> unit Monad.t
  end

  module Client : sig
    val get
        :  ?headers:Cohttp.Header.t
        -> Uri.t
        -> (Cohttp.Response.t * Body.t) t

    val head : ?headers:Cohttp.Header.t -> Uri.t -> Cohttp.Response.t t

    val delete
        :  ?headers:Cohttp.Header.t
        -> ?chunked:bool
        -> ?body:Body.t
        -> Uri.t
        -> (Cohttp.Response.t * Body.t) t

    val post
        :  ?headers:Cohttp.Header.t
        -> ?chunked:bool
        -> ?body:Body.t
        -> Uri.t
        -> (Cohttp.Response.t * Body.t) t

    val put
        :  ?headers:Cohttp.Header.t
        -> ?chunked:bool
        -> ?body:Body.t
        -> Uri.t
        -> (Cohttp.Response.t * Body.t) t

    val patch
        :  ?headers:Cohttp.Header.t
        -> ?chunked:bool
        -> ?body:Body.t
        -> Uri.t
        -> (Cohttp.Response.t * Body.t) t

    val post_form
        :  ?headers:Cohttp.Header.t
        -> params:(string * string list) list
        -> Uri.t
        -> (Cohttp.Response.t * Body.t) t
  end
end
