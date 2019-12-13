open Ctypes

module Def (F : Cstubs.FOREIGN) = struct
  open F

  module Types = Sys_time_types.Def(Sys_time_generated_types)

  open Types

  let getitimer = foreign "getitimer" (int @-> ptr Itimerval.t @-> (returning int))
  let setitimer = foreign "setitimer" (int @-> ptr Itimerval.t @-> ptr Itimerval.t @-> (returning int))

  let gettimeofday = foreign "gettimeofday" (ptr Timeval.t @-> ptr void @-> (returning int))  
  
  let fd_zero = foreign "ocaml_sys_time_fd_zero" (ptr Sys_time_types.fd_set @-> (returning void))
  let fd_set = foreign "ocaml_sys_time_fd_set" (int @-> ptr Sys_time_types.fd_set @-> (returning void))
  let fd_isset = foreign "ocaml_sys_time_fd_isset" (int @-> ptr Sys_time_types.fd_set @-> (returning int))
  let fd_clr = foreign "ocaml_sys_time_fd_clr" (int @-> ptr Sys_time_types.fd_set @-> (returning void))

  let select = foreign "select" (int @-> ptr Sys_time_types.fd_set @-> ptr Sys_time_types.fd_set @-> ptr Sys_time_types.fd_set @-> ptr Timeval.t @-> (returning int))

  let  utimes = foreign "utimes" (string @-> ptr Timeval.t @-> (returning int))
end
