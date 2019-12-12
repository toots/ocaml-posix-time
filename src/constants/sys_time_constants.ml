module Def (S : Cstubs.Types.TYPE) = struct
  let time_len = S.constant "TIME_T_LEN" S.int
  let suseconds_len = S.constant "SUSECONDS_T_LEN" S.int
end
