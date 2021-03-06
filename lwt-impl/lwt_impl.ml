module Make (C : Cohttp_lwt.S.Client) = struct
  type 'a t = 'a Lwt.t

  module Monad = struct
    type nonrec 'a t = 'a t
    let (>|=) = Lwt.(>|=)
    let (>>=) = Lwt.(>>=)
    let return = Lwt.return
  end

  module Body = struct
    type stream = string Lwt_stream.t

    type t = [
      | Cohttp.Body.t
      | `Stream of stream
    ]

    let to_string = Cohttp_lwt.Body.to_string

    let to_string_list = Cohttp_lwt.Body.to_string_list

    let empty = Cohttp_lwt.Body.empty

    let map = Cohttp_lwt.Body.map

    let transfer_encoding = Cohttp_lwt.Body.transfer_encoding

    let is_empty = Cohttp_lwt.Body.is_empty

    let of_string = Cohttp_lwt.Body.of_string

    let of_string_list = Cohttp_lwt.Body.of_string_list

    let to_stream = Cohttp_lwt.Body.to_stream

    let of_stream = Cohttp_lwt.Body.of_stream

    let drain_body = Cohttp_lwt.Body.drain_body
  end

  module Client = struct
    let get ?headers uri = C.get ?headers uri

    let head ?headers uri = C.head ?headers uri

    let delete ?headers ?chunked ?body uri =
      C.delete ?headers ?chunked ?body uri

    let post ?headers ?chunked ?body uri = C.post ?headers ?chunked ?body uri

    let put ?headers ?chunked ?body uri = C.put ?headers ?chunked ?body uri

    let patch ?headers ?chunked ?body uri = C.patch ?headers ?chunked ?body uri

    let post_form ?headers ~params uri = C.post_form ?headers ~params uri
  end
end
