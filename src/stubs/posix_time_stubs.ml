open Ctypes

module Def (F : Cstubs.FOREIGN) = struct
  open F

  module Types = Posix_time_types.Def(Posix_time_generated_types)

  open Types

  let getitimer = foreign "getitimer" (int @-> ptr Itimerval.t @-> (returning int))
  let setitimer = foreign "setitimer" (int @-> ptr Itimerval.t @-> ptr Itimerval.t @-> (returning int))

  let gettimeofday = foreign "gettimeofday" (ptr Timeval.t @-> ptr void @-> (returning int))  
  
  let fd_zero = foreign "ocaml_posix_time_fd_zero" (ptr Posix_time_types.fd_set @-> (returning void))
  let fd_set = foreign "ocaml_posix_time_fd_set" (int @-> ptr Posix_time_types.fd_set @-> (returning void))
  let fd_isset = foreign "ocaml_posix_time_fd_isset" (int @-> ptr Posix_time_types.fd_set @-> (returning int))
  let fd_clr = foreign "ocaml_posix_time_fd_clr" (int @-> ptr Posix_time_types.fd_set @-> (returning void))

  let select = foreign "select" (int @-> ptr Posix_time_types.fd_set @-> ptr Posix_time_types.fd_set @-> ptr Posix_time_types.fd_set @-> ptr Timeval.t @-> (returning int))

  let  utimes = foreign "utimes" (string @-> ptr Timeval.t @-> (returning int))
end
