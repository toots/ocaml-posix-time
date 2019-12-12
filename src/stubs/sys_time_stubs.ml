open Ctypes

module Def (F : Cstubs.FOREIGN) = struct
  open F

  module Types = Sys_time_types.Def(Sys_time_generated_types)

  open Types

  let gettimeofday = foreign "gettimeofday" (ptr Timeval.t @-> ptr void @-> (returning int))  
end
