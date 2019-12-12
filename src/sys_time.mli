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

val getitimer : itimer -> itimerval
val setitimer : itimer -> itimerval -> itimerval

val gettimeofday : unit -> timeval

val select : Unix.file_descr list ->
  Unix.file_descr list ->
  Unix.file_descr list ->
  timeval -> Unix.file_descr list * Unix.file_descr list * Unix.file_descr list

val utimes: string -> timeval -> unit
