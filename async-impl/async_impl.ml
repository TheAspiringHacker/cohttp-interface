type 'a t = 'a Async_kernel.Deferred.t

module Monad = struct
  type nonrec 'a t = 'a t
  let (>|=) = Async_kernel.(>>|)
  let (>>=) = Async_kernel.(>>=)
  let return = Async_kernel.return
end

module Body = struct
  type stream = Base.string Async_kernel.Pipe.Reader.t

  type t = [
    | Cohttp.Body.t
    | `Stream of stream
  ]

  let of_async_body : Cohttp_async.Body.t -> t = function
    | `Pipe x -> `Stream x
    | (`Empty | `String _ | `Strings _) as x -> x

  let to_async_body = function
    | `Stream x -> `Pipe x
    | (`Empty | `String _ | `Strings _) as x -> x

  let convert f x = of_async_body (f x)

  let to_string t = to_async_body t |> Cohttp_async.Body.to_string

  let to_string_list t = to_async_body t |> Cohttp_async.Body.to_string_list

  let empty = of_async_body Cohttp_async.Body.empty

  let map f a = of_async_body (Cohttp_async.Body.map ~f (to_async_body a))

  let transfer_encoding t =
    to_async_body t |> Cohttp_async.Body.transfer_encoding

  let is_empty t = to_async_body t |> Cohttp_async.Body.is_empty

  let of_string = convert Cohttp_async.Body.of_string

  let of_string_list = convert Cohttp_async.Body.of_string_list

  let to_stream t = to_async_body t |> Cohttp_async.Body.to_pipe

  let of_stream = convert Cohttp_async.Body.of_pipe

  let drain_body t = to_async_body t |> Cohttp_async.Body.drain
end

module Client = struct
  let convert x =
    let open Async_kernel in
    x >>| fun (resp, body) -> (resp, Body.of_async_body body)

  let get ?headers uri =
    convert (Cohttp_async.Client.get ?headers uri)

  let map_opt f = function
    | None -> None
    | Some x -> Some (f x)

  let head ?headers uri = Cohttp_async.Client.head ?headers uri

  let delete ?body ?chunked ?headers uri =
    let body = map_opt Body.to_async_body body in
    convert (Cohttp_async.Client.delete ?body ?chunked ?headers uri)

  let post ?headers ?chunked ?body uri =
    let body = map_opt Body.to_async_body body in
    convert (Cohttp_async.Client.post ?headers ?chunked ?body uri)

  let put ?headers ?chunked ?body uri =
    let body = map_opt Body.to_async_body body in
    convert (Cohttp_async.Client.put ?headers ?chunked ?body uri)

  let patch ?body ?chunked ?headers uri =
    let body = map_opt Body.to_async_body body in
    convert (Cohttp_async.Client.patch ?body ?chunked ?headers uri)

  let post_form ?headers ~params uri =
    convert (Cohttp_async.Client.post_form ?headers ~params uri)
end
