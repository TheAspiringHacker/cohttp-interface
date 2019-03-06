module type S = sig
  type 'a t

  module Monad : sig
    type nonrec 'a t = 'a t
    val (>|=) : 'a t -> ('a -> 'b) -> 'b t
    val (>>=) : 'a t -> ('a -> 'b t) -> 'b t
  end

  module Body : sig
    type streamer

    type t = [
      | Cohttp.Body.t
      | `Stream of streamer
      ]

    val to_string : t -> string Monad.t

    val to_string_list : t -> string list Monad.t

    val empty : t

    val of_string : string -> t

    val of_string_list : string list -> t

    val map : (string -> string) -> t -> t
  end

  module Client : sig
    val get
        :  ?headers:Cohttp.Header.t
        -> Uri.t
        -> (Cohttp.Response.t * Body.t) t

    val head : ?headers:Cohttp.Header.t -> Uri.t -> Cohttp.Response.t t

    val delete
        :  ?body:Body.t
        -> ?chunked:bool
        -> ?headers:Cohttp.Header.t
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
        :  ?body:Body.t
        -> ?chunked:bool
        -> ?headers:Cohttp.Header.t
        -> Uri.t
        -> (Cohttp.Response.t * Body.t) t

    val post_form
        :  ?headers:Cohttp.Header.t
        -> params:(string * string list) list
        -> Uri.t
        -> (Cohttp.Response.t * Body.t) t
  end
end
