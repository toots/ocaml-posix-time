module Constants = Sys_time_constants.Def(Sys_time_generated_constants)

include Constants

module type Time = sig
  type time
  val int64_of_time : time -> int64
  val time_of_int64 : int64 -> time

  module T : functor (S : Cstubs.Types.TYPE) -> sig
    val t : time S.typ
  end
end

let time : (module Time)  =
    match Constants.time_len with
      | 1 ->  (module struct
                 type time = int
                 let int64_of_time = Int64.of_int
                 let time_of_int64 = Int64.to_int
                 module T (S : Cstubs.Types.TYPE) = struct
                   let t = S.int8_t
                 end
               end)
      | 2 -> (module struct
                 type time = int
                 let int64_of_time = Int64.of_int
                 let time_of_int64 = Int64.to_int
                 module T (S : Cstubs.Types.TYPE) = struct
                   let t = S.int16_t
                 end
               end)
      | 4 -> (module struct
                 type time = int32
                 let int64_of_time = Int64.of_int32
                 let time_of_int64 = Int64.to_int32
                 module T (S : Cstubs.Types.TYPE) = struct
                   let t = S.int32_t
                 end
               end)
      | 8 -> (module struct
                 type time = int64
                 let int64_of_time v = v
                 let time_of_int64 v = v
                 module T (S : Cstubs.Types.TYPE) = struct
                   let t = S.int64_t
                 end
               end)
      | _ -> assert false

module Time = (val time : Time)

module type Suseconds = sig
  type suseconds
  val int64_of_suseconds : suseconds -> int64
  val suseconds_of_int64 : int64 -> suseconds

  module T : functor (S : Cstubs.Types.TYPE) -> sig
    val t : suseconds S.typ
  end
end

let suseconds : (module Suseconds)  =
    match Constants.suseconds_len with
      | 1 ->  (module struct
                 type suseconds = int
                 let int64_of_suseconds = Int64.of_int
                 let suseconds_of_int64 = Int64.to_int
                 module T (S : Cstubs.Types.TYPE) = struct
                   let t = S.int8_t
                 end
               end)
      | 2 -> (module struct
                 type suseconds = int
                 let int64_of_suseconds = Int64.of_int
                 let suseconds_of_int64 = Int64.to_int
                 module T (S : Cstubs.Types.TYPE) = struct
                   let t = S.int16_t
                 end
               end)
      | 4 -> (module struct
                 type suseconds = int32
                 let int64_of_suseconds = Int64.of_int32
                 let suseconds_of_int64 = Int64.to_int32
                 module T (S : Cstubs.Types.TYPE) = struct
                   let t = S.int32_t
                 end
               end)
      | 8 -> (module struct
                 type suseconds = int64
                 let int64_of_suseconds v = v
                 let suseconds_of_int64 v = v
                 module T (S : Cstubs.Types.TYPE) = struct
                   let t = S.int64_t
                 end
               end)
      | _ -> assert false

module Suseconds = (val suseconds : Suseconds)

module Types = struct
  type time = Time.time
  let int64_of_time = Time.int64_of_time
  let time_of_int64 = Time.time_of_int64

  type suseconds = Suseconds.suseconds
  let int64_of_suseconds = Suseconds.int64_of_suseconds
  let suseconds_of_int64 = Suseconds.suseconds_of_int64 

  module T(S : Cstubs.Types.TYPE) = struct
    module TimeT = Time.T(S)
    let time_t = TimeT.t

    module SusecondsT = Suseconds.T(S)
    let suseconds_t = SusecondsT.t
  end
end

module Def (S : Cstubs.Types.TYPE) = struct
  module TT = Types.T(S)

  include TT

  module Timeval = struct
    type t = unit
    let t = S.structure "timeval"
    let tv_sec = S.field t "tv_sec" TT.time_t
    let tv_usec = S.field t "tv_usec" TT.suseconds_t
    let () = S.seal t
  end

  module Itimerval = struct
    type t = unit
    let t = S.structure "itimerval"
    let it_interval = S.field t "it_interval" Timeval.t
    let it_value = S.field t "it_value" Timeval.t
    let () = S.seal t
  end

  module FdSet = struct
    type t = unit
    let t = S.structure "fd_set"
    let fds_bits = S.field t "fds_bits" (S.array fds_bits_len S.int)
    let () = S.seal t
  end
end
