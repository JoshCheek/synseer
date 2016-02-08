'use strict';

const Keybinding = require('./keybinding');
let bindingFor = Keybinding.for;
let groupFor   = Keybinding.Group.for;

module.exports = groupFor('All Keybindings', '', [
  groupFor('Convenience', '', [
    bindingFor('send',  'm', 'method call'),
    bindingFor('str',   's', 'literal string'),
    bindingFor('lvar',  'l', 'lookup local variable'),
    bindingFor('const', 'C', 'lookup constant'),
    bindingFor('sym',   'y', 'symbol literal (or S)'),
    bindingFor('int',   'i', 'integer literal'),
    bindingFor('def',   'd', 'def'),
    bindingFor('hash',  'h', 'hash literal'),
    bindingFor('block', 'b', 'literal block'),
    bindingFor('ivar',  '@', 'lookup instance variable'),
    bindingFor('array', 'A', 'array literal'),
  ]),


  groupFor('Hierarchy', '', [
    groupFor('lookup', '-', [
      bindingFor('lvar',     'l', 'local variable'),
      bindingFor('const',    'C', 'constant'),
      bindingFor('ivar',     '@', 'instance variable'),
      bindingFor('gvar',     '$', 'global variable'),
      bindingFor('cbase',    'o', 'toplevel constant (Object)'),
      bindingFor('nth_ref',  'n', 'regexp capture'),
      bindingFor('back_ref', '&', 'regexp match'),
      bindingFor('cvar',     'c', 'class var (never use these)'),
    ]),

    groupFor('assign', '=', [
      bindingFor('lvasgn',   'l', 'local variable'),
      bindingFor('ivasgn',   '@', 'instance variable'),
      bindingFor('casgn',    'C', 'constant'),
      bindingFor('or_asgn',  '|', 'assign if false'),
      bindingFor('and_asgn', '&', 'assign if true'),
      bindingFor('mlhs',     ',', 'pattern matching'),
      bindingFor('masgn',    'm', 'multiple'),
      bindingFor('op_asgn',  'o', 'operator'),
      bindingFor('gvasgn',   '$', 'global'),
      bindingFor('cvasgn',   'c', 'class var (never use these)'),
    ]),
    groupFor('control-flow', 'c', [
      bindingFor('if',     'i', 'if statement'),
      bindingFor('and',    '&', 'and'),
      bindingFor('or',     '|', 'or'),
      bindingFor('yield',  'y', 'yield to block'),
      bindingFor('return', 'r', 'return'),
      bindingFor('case',   'c', 'case'),
      groupFor('loop', 'l', [
        bindingFor('until', 'u', 'until true'),
        bindingFor('while', 'w', 'while true'),
        bindingFor('break', 'b', 'break out'),
        bindingFor('next',  'n', 'next iteration'),
      ]),
      groupFor('assign', '=', [
        bindingFor('or_asgn',  '|', 'if false'),
        bindingFor('and_asgn', '&', 'if true'),
      ]),
      groupFor('begin', 'b', [
        bindingFor('kwbegin', 'b', 'begin'),
        bindingFor('rescue',  'r', 'rescue exception'),
        bindingFor('retry',   't', 'retry the body'),
        bindingFor('ensure',  'e', 'ensure this happens'),
      ]),
      groupFor('super', 's', [
        bindingFor('zsuper', 'i', 'implicit args'),
        bindingFor('super',  'e', 'explicit args'),
      ]),
    ]),

    groupFor('object dsl', 'o', [
      bindingFor('send',  'm', 'method call'),
      bindingFor('self',  's', 'self (current object)'),
      bindingFor('alias', 'a', 'alias method'),
      groupFor('open', 'o', [
        bindingFor('class',  'c', 'class'),
        bindingFor('module', 'm', 'module'),
        bindingFor('sclass', 's', 'singleton class'),
      ]),
      groupFor('define', 'd', [
        bindingFor('def',   'd', 'on open class'),
        bindingFor('defs',  's', 'on singleton class'),
        bindingFor('undef', 'u', 'undefine in open class'),
      ]),
    ]),

    groupFor('argument', 'a', [
      bindingFor('block_pass', 'b', 'block'),
      bindingFor('splat',      'a', 'array to args'),
      bindingFor('kwsplat',    'h', 'hash keywords'),
    ]),

    groupFor('parameter', 'p', [
      bindingFor('arg',      'r', 'required'),
      bindingFor('optarg',   'o', 'optional'),
      bindingFor('restarg',  'a', 'array from rest'),
      bindingFor('blockarg', 'b', 'block'),
      groupFor('keyword', 'k', [
        bindingFor('kwarg',     'r', 'required'),
        bindingFor('kwoptarg',  'o', 'optional'),
        bindingFor('kwrestarg', 'h', 'hash from rest'),
      ]),
    ]),

    groupFor('literal', 'j', [
      bindingFor('xstr',              '`', 'system command'),
      bindingFor('regexp',            '/', 'regular expression'),
      bindingFor('match_with_lvasgn', '~', 'match regexp literal'),
      bindingFor('irange',            '2', 'range including end'),
      bindingFor('erange',            '3', 'range excluding end'),
      bindingFor('array',             'A', 'array'),
      bindingFor('block',             'b', 'block'),
      bindingFor('complex',           'c', 'complex'),
      bindingFor('defined?',          'd', 'defined?'),
      bindingFor('false',             'f', 'false'),
      bindingFor('hash',              'h', 'hash'),
      bindingFor('int',               'i', 'integer'),
      bindingFor('nil',               'n', 'nil'),
      bindingFor('float',             '.', 'floating decimal point'),
      bindingFor('rational',          'r', 'rational'),
      bindingFor('str',               's', 'string'),
      bindingFor('dstr',              'S', 'interpolated string'),
      bindingFor('true',              't', 'true'),
      bindingFor('sym',               'y', 'symbol'),
      bindingFor('dstr',              'Y', 'interpolated string'),
      bindingFor('regopt',            'o', 'regexp option'),
    ]),
  ]),
])

// Might be nice to add these as a hidden convenience,
// or maybe allow them to be programmed
// (but whos got time to implement features like that?)
//
// used:  ^ < @ - = & | /
//        a b c d f h i j l m o p rs y
//        A B F G H I J K L M N S T
// avail: e g k n q t u v w x z
//        D E O P Q R U V W X Y Z
//
//   & and
//   | or
//   / regexp
//   f if
//   T true
//   F false
//   S self
//   L class
//   N nil
//   r return
//   M module
//   B block_pass
//   G arg
//   H optarg
//   I restarg
//   J kwarg
//   K kwoptarg
//   < return
//   ^ super
//   . float
