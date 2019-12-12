open Sys_time

let () =
  let {tv_sec; tv_usec} = gettimeofday () in
  Printf.printf "gettimeofday: tv_sec: %Li, tv_usec: %Li\n" tv_sec tv_usec;
  Printf.printf "Sleeping 1s..";
  ignore(select [] [] [] {tv_sec=1L;tv_usec=0L})
