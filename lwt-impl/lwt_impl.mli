module Make : functor (C : Cohttp_lwt.S.Client) -> sig
  include Intf.S with type 'a t = 'a Lwt.t
end
