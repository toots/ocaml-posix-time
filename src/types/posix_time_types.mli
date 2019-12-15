open Ctypes

val itimer_real: int
val itimer_virtual: int
val itimer_prof: int

type fd_set
val fd_set : fd_set typ
val fd_setsize: int

module Def (S : Cstubs.Types.TYPE) : sig 
  module Timeval : sig
    type t
    val t : t structure S.typ
    val tv_sec  : (PosixTypes.time_t, t structure) S.field
    val tv_usec : (PosixTypes.suseconds_t, t structure) S.field
  end

  module Itimerval : sig
    type t
    val t : t structure S.typ
    val it_interval : (Timeval.t structure, t structure) S.field
    val it_value : (Timeval.t structure, t structure) S.field
  end
end
