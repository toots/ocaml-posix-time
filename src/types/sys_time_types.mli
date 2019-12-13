open Ctypes

val itimer_real: int
val itimer_virtual: int
val itimer_prof: int

val fd_setsize: int

module Types : sig
  type time
  val int64_of_time : time -> int64
  val time_of_int64 : int64 -> time

  type suseconds
  val int64_of_suseconds : suseconds -> int64
  val suseconds_of_int64 : int64 -> suseconds

  module T : functor (S : Cstubs.Types.TYPE) -> sig
    val time_t      : time S.typ
    val suseconds_t : suseconds S.typ 
  end
end

module Def (S : Cstubs.Types.TYPE) : sig 
  val time_t      : Types.time S.typ
  val suseconds_t : Types.suseconds S.typ

  module Timeval : sig
    type t
    val t : t structure S.typ
    val tv_sec  : (Types.time, t structure) S.field
    val tv_usec : (Types.suseconds, t structure) S.field
  end

  module Itimerval : sig
    type t
    val t : t structure S.typ
    val it_interval : (Timeval.t structure, t structure) S.field
    val it_value : (Timeval.t structure, t structure) S.field
  end

  module FdSet : sig
    type t
    val t : t structure S.typ
    val fds_bits : (int carray, t structure) S.field
  end 
end
