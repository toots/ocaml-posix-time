open Ctypes

module Constants = Posix_time_constants.Def(Posix_time_generated_constants)

include Constants

type fd_set = unit Ctypes.abstract
let fd_set =
  Ctypes.abstract ~name:"fd_set" ~size:fd_set_size
                  ~alignment:fd_set_alignment

module Def (S : Cstubs.Types.TYPE) = struct
  module Timeval = struct
    type t = unit
    let t =
      S.structure "timeval"
    let tv_sec =
      S.field t "tv_sec" (S.lift_typ PosixTypes.time_t)
    let tv_usec =
      S.field t "tv_usec" (S.lift_typ PosixTypes.suseconds_t)
    let () =
      S.seal t
  end

  module Itimerval = struct
    type t = unit
    let t =
      S.structure "itimerval"
    let it_interval =
      S.field t "it_interval" Timeval.t
    let it_value =
      S.field t "it_value" Timeval.t
    let () =
      S.seal t
  end
end
