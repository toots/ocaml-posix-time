type timeval = {
  tv_sec:  int64;
  tv_usec: int64
}

val gettimeofday : unit -> timeval
val select : Unix.file_descr list ->
  Unix.file_descr list ->
  Unix.file_descr list ->
  timeval -> Unix.file_descr list * Unix.file_descr list * Unix.file_descr list
