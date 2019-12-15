module Def (S : Cstubs.Types.TYPE) = struct
  let itimer_real = S.constant "ITIMER_REAL" S.int
  let itimer_virtual = S.constant "ITIMER_VIRTUAL" S.int
  let itimer_prof = S.constant "ITIMER_PROF" S.int
  let time_len = S.constant "TIME_T_LEN" S.int
  let suseconds_len = S.constant "SUSECONDS_T_LEN" S.int
  let fd_setsize = S.constant "FD_SETSIZE" S.int
  let fd_set_size = S.constant "FD_SET_SIZE" S.int
  let fd_set_alignment = S.constant "FD_SET_ALIGNMENT" S.int
end
