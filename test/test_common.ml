open Cohttp

module Make (I : Intf.S) = struct
  open I
  open I.Monad

  (* Adapted from
     https://github.com/mirage/ocaml-cohttp/blob/f865109ef1b9b1f5841ff2bcfb6356c6da22232b/examples/doc/client_lwt.ml *)
  let action =
    Client.get (Uri.of_string "http://ocaml.org/") >>= fun (resp, body) ->
    let code = resp |> Response.status |> Code.code_of_status in
    Printf.printf "Response code: %d\n" code;
    Printf.printf "Headers: %s\n"
      (resp |> Response.headers |> Header.to_string);
    body |> I.Body.to_string >|= fun body ->
    Printf.printf "Body of length: %d\n" (String.length body);
    print_endline ("Received body\n" ^ body)
end
