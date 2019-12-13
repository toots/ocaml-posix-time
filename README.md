# sys-time

This module provides OCaml ctypes bindings to system-specific low-level time-related structures, functions and data-types.

The interface is implemented using [ocaml-ctypes](https://github.com/ocamllabs/ocaml-ctypes) and is intended
to exposed the machine-specific, low-level details of the most important parts of socket implementations.

The C API bound in this module is defined on POSIX systems by the [sys/time.h](https://pubs.opengroup.org/onlinepubs/7908799/xsh/systime.h.html) header

The low-level API mirrors as much as possible the original POSIX definitions. It is defined in [sys_time_types.mli](src/types/sys_time_types.mli). This API can be used to build further C bindings using `ocaml-ctypes`.

[Sys_time.mli](src/sys_time.mli) provides a high-level API compatible exported from the low-level bindings.

Happy hacking!
