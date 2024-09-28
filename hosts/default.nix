{ mylib, vars, ... }:

with mylib; {
  host = utils.match { host = vars.host or "dtsf-machine"; } [
    [{ host = "dtsf-machine"; } (import ./dtsf-machine)]
    [{ host = "dtsf-book"; } (import ./dtsf-book)]
  ];
}
