module type S = sig
  module Body : sig
    type streamer

    type t = [
      | Cohttp.Body.t
      | `Stream of streamer
      ]

    val empty : t

    val of_string : string -> t

    val of_string_list : string list -> t

    val map : (string -> string) -> t -> t
  end

  module Client : sig
    type 'a t

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
