module Lwt_unix_impl = Lwt_impl.Make(Cohttp_lwt_unix.Client)
module Tests = Test_common.Make(Lwt_unix_impl)
let () =
  Lwt_main.run Tests.action;
  print_endline "Lwt done"
