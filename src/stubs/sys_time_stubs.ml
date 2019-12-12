open Ctypes

module Def (F : Cstubs.FOREIGN) = struct
  open F

  module Types = Sys_time_types.Def(Sys_time_generated_types)

  open Types

  let gettimeofday = foreign "gettimeofday" (ptr Timeval.t @-> ptr void @-> (returning int))  
  
  let fd_zero = foreign "ocaml_sys_time_fd_zero" (ptr void @-> (returning void))
  let fd_set = foreign "ocaml_sys_time_fd_set" (int @-> ptr void @-> (returning void))
  let fd_isset = foreign "ocaml_sys_time_fd_isset" (int @-> ptr void @-> (returning int))
  let fd_clr = foreign "ocaml_sys_time_fd_clr" (int @-> ptr void @-> (returning void))

  let select = foreign "select" (int @-> ptr void @-> ptr void @-> ptr void @-> ptr Timeval.t @-> (returning int))
end
