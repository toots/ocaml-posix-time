(* High-level API to <time.h> and <sys/time.h>.
 * See: https://pubs.opengroup.org/onlinepubs/9699919799/basedefs/time.h.html
 * and: https://pubs.opengroup.org/onlinepubs/7908799/xsh/systime.h.html
 * for an explanation about the data structures and functions. *)

(* Size of [tv_sec] and [tv_nsec] are architecture-specific. We provide
 * here the largest size possible in order to make computations as safe
 * as possible from overflows. However, you should make sure that [tv_nsec]
 * is always kept below [1_000_000_000L] before passing one such record to the
 * consuming functions in order to avoid potential overflow. *)
type timespec = {
  tv_sec:  int64;
  tv_nsec: int64
}

(* Size of [tv_sec] and [tv_usec] are architecture-specific. We provide
 * here the largest size possible in order to make computations as safe
 * as possible from overflows. However, you should make sure that [tv_usec]
 * is always kept below [1_000_000L] before passing one such record to the
 * consuming functions in order to avoid potential overflow. *)
type timeval = {
  tv_sec:  int64;
  tv_usec: int64
}

type itimerval = {
  it_interval: timeval;
  it_value: timeval
}

type itimer = [
  | `Real
  | `Virtual
  | `Prof
]

type clock = [
  | `Realtime
  | `Monotonic
  | `Process_cputime
  | `Thread_cputime
]

val clock_getres: clock -> timespec
val clock_gettime: clock -> timespec
val clock_settime: clock -> timespec -> unit

val nanosleep : timespec -> unit

val getitimer : itimer -> itimerval
val setitimer : itimer -> itimerval -> itimerval

val gettimeofday : unit -> timeval

(* [select] behaviour should be exactly the same as the C equivalent.
 * Passing [None] for [timeval] is equivalent to passing a [NULL] pointer
 * in a C call. *)
val select : Unix.file_descr list ->
  Unix.file_descr list ->
  Unix.file_descr list ->
  timeval option -> Unix.file_descr list * Unix.file_descr list * Unix.file_descr list

val utimes: string -> timeval -> unit
