let c_headers = "
#include <sys/time.h>

#define TIME_T_LEN sizeof(time_t)
#define SUSECONDS_T_LEN sizeof(suseconds_t)
#define FD_SET_LEN sizeof(fd_set)
#define FDS_BITS_LEN (sizeof(((struct fd_set*)0)->fds_bits)/sizeof(long))
"

let () =
  let fname = Sys.argv.(1) in
  let oc = open_out_bin fname in
  let format =
    Format.formatter_of_out_channel oc
  in
  Format.fprintf format "%s@\n" c_headers;
  Cstubs.Types.write_c format (module Sys_time_constants.Def);
  Format.pp_print_flush format ();
  close_out oc
