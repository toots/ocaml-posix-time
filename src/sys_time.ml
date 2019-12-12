open Ctypes

include Sys_time_stubs.Def(Sys_time_generated_stubs)

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

let int_of_itimer = function
  | `Real -> Sys_time_types.itimer_real
  | `Virtual -> Sys_time_types.itimer_virtual
  | `Prof -> Sys_time_types.itimer_prof

let to_timeval timeval =
  let get f = getf timeval f in
  { tv_sec  = Sys_time_types.Types.int64_of_time (get Types.Timeval.tv_sec);
    tv_usec = Sys_time_types.Types.int64_of_suseconds (get Types.Timeval.tv_usec) }

let from_timeval {tv_sec;tv_usec} =
  let timeval = make Types.Timeval.t in
  setf timeval Types.Timeval.tv_sec
    (Sys_time_types.Types.time_of_int64 tv_sec);
  setf timeval Types.Timeval.tv_usec
    (Sys_time_types.Types.suseconds_of_int64 tv_usec);
  timeval

let to_itimerval itimerval =
   let get f = getf itimerval f in
  { it_interval = to_timeval (get Types.Itimerval.it_interval);
    it_value = to_timeval (get Types.Itimerval.it_value) }

let from_itimerval {it_interval;it_value} =
  let itimerval = make Types.Itimerval.t in
  setf itimerval Types.Itimerval.it_interval
    (from_timeval it_interval);
  setf itimerval Types.Itimerval.it_value
    (from_timeval it_value);
  itimerval

let setitimer timer v =
  Errno_unix.with_unix_exn (fun () ->
    Errno_unix.raise_on_errno (fun () ->
      let v = from_itimerval v in
      let old =
        allocate_n Types.Itimerval.t ~count:1
      in
      match setitimer (int_of_itimer timer) (addr v) old with
        | x when x < 0 -> None
        | _ -> Some (to_itimerval (!@ old))))

let getitimer timer =
  Errno_unix.with_unix_exn (fun () ->
    Errno_unix.raise_on_errno (fun () ->
      let v =
        allocate_n Types.Itimerval.t ~count:1
      in
      match getitimer (int_of_itimer timer) v  with
        | x when x < 0 -> None
        | _ -> Some (to_itimerval (!@ v))))

let gettimeofday () =
  Errno_unix.with_unix_exn (fun () ->
    Errno_unix.raise_on_errno (fun () ->
      let timeval =
        allocate_n Types.Timeval.t ~count:1 
      in
      match gettimeofday timeval null with
        | x when x < 0 -> None
        | _ -> Some (to_timeval (!@ timeval))))

let select r w e timeval =
  Errno_unix.with_unix_exn (fun () ->
    Errno_unix.raise_on_errno (fun () ->
      if List.length r > Sys_time_types.fd_setsize then
        failwith "too many read sockets!";
      if List.length w > Sys_time_types.fd_setsize then
        failwith "too many write sockets!";
      if List.length e > Sys_time_types.fd_setsize then
        failwith "too many exception sockets!";
      let nfds =
        List.length r + List.length w + List.length e
      in
      let mk_fd_set l =
        let set =
          to_voidp 
            (allocate_n char ~count:Sys_time_types.fd_set_len)
        in 
        List.iter (fun fd ->
          fd_set (Obj.magic fd) set) l;
        set
     in
     let r_set = mk_fd_set r in
     let w_set = mk_fd_set w in
     let e_set = mk_fd_set e in
     let timeval = from_timeval timeval in
     match select nfds r_set w_set e_set (addr timeval) with
       | x when x < 0 -> None
       | _ ->
         let get_fd_set l fd_set =
           List.filter (fun fd ->
             fd_isset (Obj.magic fd) fd_set <> 0) l
         in
         Some ((get_fd_set r r_set,
                get_fd_set w w_set,
                get_fd_set e e_set))))

let utimes path timeval =
  Errno_unix.with_unix_exn (fun () ->
    Errno_unix.raise_on_errno (fun () ->
      let timeval = from_timeval timeval in
      match utimes path (addr timeval) with
        | x when x < 0 -> None
        | _ -> Some ()))
