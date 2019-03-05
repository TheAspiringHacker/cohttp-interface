module Make : functor (C : Cohttp_lwt.S.Client) -> sig
  include Intf.S
end
