open Ctypes

include Sys_time_stubs.Def(Sys_time_generated_stubs)

type timeval = {
  tv_sec:  int64;
  tv_usec: int64
}

let to_timeval timeval =
  let get f = !@ (timeval |-> f) in
  { tv_sec  = Sys_time_types.Types.int64_of_time (get Types.Timeval.tv_sec);
    tv_usec = Sys_time_types.Types.int64_of_suseconds (get Types.Timeval.tv_usec) }

let gettimeofday () =
  Errno_unix.with_unix_exn (fun () ->
    Errno_unix.raise_on_errno (fun () ->
      let timeval =
        allocate_n Types.Timeval.t ~count:1 
      in
      match gettimeofday timeval null with
        | x when x < 0 -> None
        | _ -> Some (to_timeval timeval)))


