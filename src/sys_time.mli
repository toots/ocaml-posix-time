type timeval = {
  tv_sec:  int64;
  tv_usec: int64
}

val gettimeofday : unit -> timeval
