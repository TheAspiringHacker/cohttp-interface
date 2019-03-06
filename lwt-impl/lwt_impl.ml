module Make (C : Cohttp_lwt.S.Client) = struct
  type 'a t = 'a Lwt.t

  module Monad = struct
    type nonrec 'a t = 'a t
    let (>|=) = Lwt.(>|=)
    let (>>=) = Lwt.(>>=)
  end

  module Body = struct
    type streamer = string Lwt_stream.t

    type t = [
      | Cohttp.Body.t
      | `Stream of streamer
      ]

    let to_string = Cohttp_lwt.Body.to_string

    let to_string_list = Cohttp_lwt.Body.to_string_list

    let empty = Cohttp_lwt.Body.empty

    let of_string = Cohttp_lwt.Body.of_string

    let of_string_list = Cohttp_lwt.Body.of_string_list

    let map = Cohttp_lwt.Body.map
  end

  module Client = struct
    let get ?headers uri = C.get ?headers uri

    let head ?headers uri = C.head ?headers uri

    let delete ?body ?chunked ?headers uri =
      C.delete ?body ?chunked ?headers uri

    let post ?headers ?chunked ?body uri = C.post ?headers ?chunked ?body uri

    let put ?headers ?chunked ?body uri = C.put ?headers ?chunked ?body uri

    let patch ?body ?chunked ?headers uri = C.patch ?body ?chunked ?headers uri

    let post_form ?headers ~params uri = C.post_form ?headers ~params uri
  end
end
