'use strict';

const Keybinding = require('./keybinding');

function keybindingFor(keysequence, data, english) {
  return new Keybinding({
    keysequence: keysequence,
    data:        data,
    english:     english,
  });
}


module.exports = [
  // setters
  keybindingFor("sc",  "casgn",   'set constant'),
  keybindingFor("sm",  "masgn",   'set constant... uhm, idk'),
  keybindingFor("si",  "ivasgn",  'set instance variable'),
  keybindingFor("sl",  "lvasgn",  'set local variable'),
  keybindingFor("sop", "op_asgn", 'set with an operator'),
  keybindingFor("sor", "or_asgn", 'set with ||'),

  // getters
  keybindingFor("gc", "const", 'get constant'),
  keybindingFor("gi", "ivar",  'get instance variable'),
  keybindingFor("gl", "lvar",  'get local variable'),
  keybindingFor("gg", "gvar",  'get global variable'),

  // arg things
  keybindingFor("aba",  "blockarg",   'argument: block arg'),
  keybindingFor("abl",  "block",      'argument: block arg'),
  keybindingFor("abp",  "block_pass", 'argument: block pass'),
  keybindingFor("ag",   "arg",        'argument: regular'),
  keybindingFor("aog",  "optarg",     'argument: optional'),
  keybindingFor("ak",   "kwarg",      'argument: keyword'),
  keybindingFor("aok",  "kwoptarg",   'argument: optional keyword'),
  keybindingFor("ar",   "restarg",    'argument: rest of the args'),
  keybindingFor("as",   "args",       'arguments'),

  // control flow keywords
  keybindingFor("ca",   "and",     'control-flow: and'),
  keybindingFor("cbr",  "break",   'control-flow: break'),
  keybindingFor("cbe",  "kwbegin", 'control-flow: keyword begin'),
  keybindingFor("cca",  "case",    'control-flow: case'),
  keybindingFor("ccw",  "when",    'control-flow: case/when'),
  keybindingFor("ce",   "ensure",  'control-flow: ensure'),
  keybindingFor("cn",   "next",    'control-flow: next'),
  keybindingFor("co",   "or",      'control-flow: or'),
  keybindingFor("ci",   "if",      'control-flow: if'),
  keybindingFor("cre",  "return",  'control-flow: return'),
  keybindingFor("crs",  "rescue",  'control-flow: rescue'),
  keybindingFor("crb",  "resbody", 'control-flow: rescue body (I think)'),
  keybindingFor("cs",   "super",   'control-flow: super'),
  keybindingFor("cu",   "until",   'control-flow: until'),
  keybindingFor("cw",   "while",   'control-flow: while'),
  keybindingFor("cy",   "yield",   'control-flow: yield'),

  // literals
  keybindingFor("la",   "array",  'literal array'),
  keybindingFor("lf",   "false",  'literal false'),
  keybindingFor("lt",   "true",   'literal true'),
  keybindingFor("lh",   "hash",   'literal hash'),
  keybindingFor("li",   "int",    'literal integer'),
  keybindingFor("ll",   "float",  'literal float'),
  keybindingFor("ln",   "nil",    'literal nil'),
  keybindingFor("ls",   "str",    'literal string'),
  keybindingFor("ly",   "sym",    'literal symbol'),
  keybindingFor("lr",   "regexp", 'literal regexp'),
  keybindingFor("lo",   "regopt", 'literal regexp option'),
  keybindingFor("ld",   "dstr",   'literal.... uhm, not sure (I think this is interpolation)'),

  // oo dls
  keybindingFor("om",   "module", 'Object Oriented: module'),
  keybindingFor("oc",   "class",  'Object Oriented: class'),
  keybindingFor("odf",  "def",    'Object Oriented: define a method'),
  keybindingFor("ods",  "defs",   'Object Oriented: define a singleton method'),
  keybindingFor("os",   "self",   'Object Oriented: self'),

  // not sure yet
  keybindingFor("ir",   "irange", 'irange ??'),
  keybindingFor("mlhs", "mlhs",   '?? maybe "multiple left-hand setting" or something'),
  keybindingFor("p",    "pair",   '?? part of a hash'),
  keybindingFor("b",    "begin",  'implicit grouping of expressions'),
  keybindingFor("ms",   "send",   'message send'),
  keybindingFor("sp",   "splat",  '?? guessing this is the complement to restarg'),
  keybindingFor("P",    "program", 'whole program'),
]
