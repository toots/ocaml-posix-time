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

let select r w e {tv_sec;tv_usec} =
  Errno_unix.with_unix_exn (fun () ->
    Errno_unix.raise_on_errno (fun () ->
      let timeval =
        allocate_n Types.Timeval.t ~count:1
      in
      (timeval |-> Types.Timeval.tv_sec) <-@ 
        (Sys_time_types.Types.time_of_int64 tv_sec);
      (timeval |-> Types.Timeval.tv_usec) <-@
        (Sys_time_types.Types.suseconds_of_int64 tv_usec);
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
     match select nfds r_set w_set e_set timeval with
       | x when x < 0 -> None
       | _ ->
         let get_fd_set l fd_set =
           List.filter (fun fd ->
             fd_isset (Obj.magic fd) fd_set <> 0) l
         in
         Some ((get_fd_set r r_set,
                get_fd_set w w_set,
                get_fd_set e e_set))))
