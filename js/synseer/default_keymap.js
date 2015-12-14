'use strict';

module.exports = {
  // setters
  "sc":    "casgn",
  "sm":    "masgn",
  "si":    "ivasgn",
  "sl":    "lvasgn",
  "sop":   "op_asgn",
  "sor":   "or_asgn",

  // getters
  "gc":    "const",
  "gi":    "ivar",
  "gl":    "lvar",
  "gg":    "gvar",

  // arg things
  "aba":   "blockarg",
  "abl":   "block",
  "abp":   "block_pass",
  "ag":    "arg",
  "aog":   "optarg",
  "ak":    "kwarg",
  "aok":   "kwoptarg",
  "as":    "args",

  // control flow keywords
  "ca":   "and",
  "cbr":  "break",
  "cbe":  "kwbegin",
  "cca":  "case",
  "ccw":  "when",
  "ce":   "ensure",
  "cn":   "next",
  "co":   "or",
  "ci":   "if",
  "cre":  "return",
  "crs":  "rescue",
  "cra":  "restarg",
  "crb":  "resbody",
  "cs":   "super",
  "cu":   "until",
  "cw":   "while",
  "cy":   "yield",

  // literals
  "la":    "array",
  "lf":    "false",
  "lt":    "true",
  "lh":    "hash",
  "li":    "int",
  "ln":    "nil",
  "ls":    "str",
  "ly":    "sym",
  "lr":    "regexp",
  "lo":    "regopt",
  "ld":    "dstr",

  // oo dls
  "om":    "module",
  "oc":    "class",
  "odf":   "def",
  "ods":   "defs",
  "os":    "self",

  // not sure yet
  "ir":    "irange",
  "mlhs":  "mlhs",
  "p":     "pair",
  "b":     "begin",
  "sp":    "splat",
  "ms":    "send", // message send
}
