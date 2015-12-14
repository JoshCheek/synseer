'use strict';

module.exports = {
  // setters
  "sc":    "casgn",     // set constant
  "sm":    "masgn",     // set constant... uhm, idk
  "si":    "ivasgn",    // set instance variable
  "sl":    "lvasgn",    // set local variable
  "sop":   "op_asgn",   // set with an operator
  "sor":   "or_asgn",   // set with ||

  // getters
  "gc":    "const", // get constant
  "gi":    "ivar",  // get instance variable
  "gl":    "lvar",  // get local variable
  "gg":    "gvar",  // get global variable

  // arg things
  "aba":   "blockarg",    // argument: block arg
  "abl":   "block",       // argument: block arg
  "abp":   "block_pass",  // argument: block pass
  "ag":    "arg",         // argument: regular
  "aog":   "optarg",      // argument: optional
  "ak":    "kwarg",       // argument: keyword
  "aok":   "kwoptarg",    // argument: optional keyword
  "ar":    "restarg",     // argument: rest of the args
  "as":    "args",        // arguments

  // control flow keywords
  "ca":   "and",     // control-flow: and
  "cbr":  "break",   // control-flow: break
  "cbe":  "kwbegin", // control-flow: keyword begin
  "cca":  "case",    // control-flow: case
  "ccw":  "when",    // control-flow: case/when
  "ce":   "ensure",  // control-flow: ensure
  "cn":   "next",    // control-flow: next
  "co":   "or",      // control-flow: or
  "ci":   "if",      // control-flow: if
  "cre":  "return",  // control-flow: return
  "crs":  "rescue",  // control-flow: rescue
  "crb":  "resbody", // control-flow: rescue body (I think)
  "cs":   "super",   // control-flow: super
  "cu":   "until",   // control-flow: until
  "cw":   "while",   // control-flow: while
  "cy":   "yield",   // control-flow: yield

  // literals
  "la":    "array",  // literal array
  "lf":    "false",  // literal false
  "lt":    "true",   // literal true
  "lh":    "hash",   // literal hash
  "li":    "int",    // literal integer
  "ln":    "nil",    // literal nil
  "ls":    "str",    // literal string
  "ly":    "sym",    // literal symbol
  "lr":    "regexp", // literal regexp
  "lo":    "regopt", // literal regexp option
  "ld":    "dstr",   // literal.... uhm, not sure (I think this is interpolation)

  // oo dls
  "om":    "module",  // Object Oriented: module
  "oc":    "class",   // Object Oriented: class
  "odf":   "def",     // Object Oriented: define a method
  "ods":   "defs",    // Object Oriented: define a singleton method
  "os":    "self",    // Object Oriented: self

  // not sure yet
  "ir":    "irange",  // ??
  "mlhs":  "mlhs",    // ?? maybe "multiple left-hand setting" or something
  "p":     "pair",    // ?? part of a hash
  "b":     "begin",   // implicit grouping of expressions
  "sp":    "splat",   // ?? guessing this is the complement to restarg
  "ms":    "send",    // message send
}
