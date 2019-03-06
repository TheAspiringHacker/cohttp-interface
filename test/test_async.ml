module Tests = Test_common.Make(Async_impl)
let _ =
  Async_kernel.upon Tests.action
    (fun () ->
      print_endline "Async done";
      Async_unix.shutdown 0);
  Async_unix.Scheduler.go ()
