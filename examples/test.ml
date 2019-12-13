open Sys_time

let sprint_timeval {tv_sec; tv_usec} =
  Printf.sprintf "tv_sec: %Li, tv_usec: %Li" tv_sec tv_usec

let sprint_itimerval {it_interval;it_value} =
  Printf.sprintf "it_interval: { %s } , it_value = { %s }" 
    (sprint_timeval it_interval) (sprint_timeval it_value)

let timer1 = {
  it_interval = {
    tv_sec = 1982L;
    tv_usec = 0L
  };
  it_value = {
    tv_sec = 0L;
    tv_usec = 0L
  }
}

let timer2 = {
  it_interval = {
    tv_sec = 0L;
    tv_usec = 0L
  };
  it_value = {
    tv_sec = 2020L;
    tv_usec = 0L
  }
}

let () =
  let timer = setitimer `Real timer1 in
  Printf.printf "setitimer: %s\n%!"
    (sprint_itimerval timer);

  let timer = getitimer `Real in
  Printf.printf "getitimer: %s\n%!"
    (sprint_itimerval timer);

  let timer = setitimer `Real timer2 in
  Printf.printf "setitimer: %s\n%!"
    (sprint_itimerval timer);

  let timer = setitimer `Real timer1 in
  Printf.printf "setitimer: %s\n%!"
    (sprint_itimerval timer);

  Printf.printf "gettimeofday: %s\n%!"
    (sprint_timeval (gettimeofday ()));

  Printf.printf "Sleeping 1s..\n%!";
  ignore(select [] [] [] (Some {tv_sec=1L;tv_usec=0L}));

  let (r, w) = Unix.pipe () in
  let th = Thread.create (fun () ->
    match select [r] [] [] None with
      | [x], [], [] when x = r ->
          Printf.printf "Done waiting on read socket!"
      | _ -> assert false) ()
  in
  ignore(Unix.write w (Bytes.of_string " ") 0 1);
  Thread.join th 
   
