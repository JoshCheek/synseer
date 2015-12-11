const map    = require('../js/synseer/default_keymap');
const Mapper = require('../js/synseer/mapper');
import assert from 'assert'; // https://github.com/joyent/node/blob/9010dd26529cea60b7ee55ddae12688f81a09fcb/lib/assert.js
import {readFile} from 'fs';
import {inspect} from 'util';

describe('map', ()=>{
  it('maps each of the keys', ()=>{
    assert.equal("and"        , map.and);
    assert.equal("arg"        , map.arg);
    assert.equal("args"       , map.ars);
    assert.equal("array"      , map.array);
    assert.equal("begin"      , map.begin);
    assert.equal("block"      , map.block);
    assert.equal("block_pass" , map.block_pass);
    assert.equal("blockarg"   , map.blockarg);
    assert.equal("break"      , map.break);
    assert.equal("case"       , map.case);
    assert.equal("casgn"      , map.casgn);
    assert.equal("class"      , map.class);
    assert.equal("const"      , map.const);
    assert.equal("def"        , map.def);
    assert.equal("defs"       , map.defs);
    assert.equal("dstr"       , map.dstr);
    assert.equal("ensure"     , map.ensure);
    assert.equal("false"      , map.false);
    assert.equal("gvar"       , map.gvar);
    assert.equal("hash"       , map.hash);
    assert.equal("if"         , map.if);
    assert.equal("int"        , map.int);
    assert.equal("irange"     , map.irange);
    assert.equal("ivar"       , map.ivar);
    assert.equal("ivasgn"     , map.ivasgn);
    assert.equal("kwarg"      , map.kwarg);
    assert.equal("kwbegin"    , map.kwbegin);
    assert.equal("kwoptarg"   , map.kwoptarg);
    assert.equal("lvar"       , map.lvar);
    assert.equal("lvasgn"     , map.lvasgn);
    assert.equal("masgn"      , map.masgn);
    assert.equal("mlhs"       , map.mlhs);
    assert.equal("module"     , map.module);
    assert.equal("next"       , map.next);
    assert.equal("nil"        , map.nil);
    assert.equal("op_asgn"    , map.op_asgn);
    assert.equal("optarg"     , map.optarg);
    assert.equal("or"         , map.or);
    assert.equal("or_asgn"    , map.or_asgn);
    assert.equal("pair"       , map.pair);
    assert.equal("regexp"     , map.regexp);
    assert.equal("regopt"     , map.regopt);
    assert.equal("resbody"    , map.resbody);
    assert.equal("rescue"     , map.rescue);
    assert.equal("restarg"    , map.restarg);
    assert.equal("return"     , map.return);
    assert.equal("self"       , map.self);
    assert.equal("send"       , map.send);
    assert.equal("splat"      , map.splat);
    assert.equal("str"        , map.str);
    assert.equal("super"      , map.super);
    assert.equal("sym"        , map.sym);
    assert.equal("true"       , map.true);
    assert.equal("until"      , map.until);
    assert.equal("when"       , map.when);
    assert.equal("while"      , map.while);
    assert.equal("yield"      , map.yield);
  });

  function assertKeyMatch(mapper, key, expected) {
    var actual = mapper.keyPressed(key);
    assert.equal(actual.length, expected.length, `Expected ${inspect(actual)} to be like ${inspect(expected)}`);
    for(var i = expected.length; i<expected.length; ++i) {
      assert.equal(actual[i], expected[i]);
    }
  }

  it('remembers my input and gives me back a list of potential matches', ()=> {
    var mapper = new Mapper(map);
    assertKeyMatch(mapper, "a", ["and", "arg", "args", "array"]);
    assertKeyMatch(mapper, "r", ["arg", "args", "array"]);
    assertKeyMatch(mapper, "r", ["array"]);
  });

  it('backspace removes a character from the end of the input', ()=> {
    var mapper = new Mapper(map);
    assertKeyMatch(mapper, "a",         ["and", "arg", "args", "array"]);
    assertKeyMatch(mapper, "r",         ["arg", "args", "array"]);
    assertKeyMatch(mapper, "backspace", ["and", "arg", "args", "array"]);
  });

  it('clears the input when escape is pressed', ()=> {
    var mapper = new Mapper(map);
    assertKeyMatch(mapper, "a", ["and", "arg", "args", "array"]);
    assertKeyMatch(mapper, "r", ["arg", "args", "array"]);

    var values = [];
    for (var key in map) { values.push(map[key]); }
    assertKeyMatch(mapper, "escape", values);
  });

  it('ignores non-printable keypresses and tab and enter', () => {
    let mapper   = new Mapper({agood: "abc", ctrl: "ctrl"});
    let expected = ['agood'];
    assertKeyMatch(mapper, "a",                      expected);

    assertKeyMatch(mapper, "alt",                    expected);
    assertKeyMatch(mapper, "cmd-alt-mod",            expected);
    assertKeyMatch(mapper, "cmd-ctrl-alt-mod",       expected);
    assertKeyMatch(mapper, "cmd-ctrl-mod",           expected);
    assertKeyMatch(mapper, "cmd-mod",                expected);
    assertKeyMatch(mapper, "ctrl",                   expected);
    assertKeyMatch(mapper, "ctrl-alt",               expected);
    assertKeyMatch(mapper, "enter",                  expected);
    assertKeyMatch(mapper, "shift-alt",              expected);
    assertKeyMatch(mapper, "shift-cmd-ctrl-alt-mod", expected);
    assertKeyMatch(mapper, "shift-cmd-ctrl-mod",     expected);
    assertKeyMatch(mapper, "shift-cmd-mod",          expected);
    assertKeyMatch(mapper, "shift-ctrl-alt",         expected);
    assertKeyMatch(mapper, "shift-ctrl-shift",       expected);
    assertKeyMatch(mapper, "shift-shift",            expected);
    assertKeyMatch(mapper, "space",                  expected);
    assertKeyMatch(mapper, "tab",                    expected);

    assertKeyMatch(mapper, "down",                   expected);
    assertKeyMatch(mapper, "left",                   expected);
    assertKeyMatch(mapper, "right",                  expected);
    assertKeyMatch(mapper, "up",                     expected);
  });

  it('has a keybinding for each type of syntax that we use', (done)=>{
    readFile('tmp/node_types', 'utf8', (err, data) => {
      if(err) assert.fail(err);
      var types = data.split("\n");
      if(types[types.length-1] === "")
        types.pop();
      var keys   = Object.keys(map);
      var values = [];
      for(var i = 0; i < keys.length; ++i) {
        values.push(map[keys[i]]);
      }
      for(var i = 0; i < types.length; ++i) {
        var type = types[i];
        if(-1 == values.indexOf(type))
          assert.fail(`No keybinding for ${type}`)
      }
      done();
    });
  });

  it('maps a given key-sequence to the requested key', () => {
    var mapper = new Mapper({abc: "lol", def: "wtf"});
    assertKeyMatch(mapper, "d", ["wtf"]);
  });

  describe('#accept', () => {
    it('clears the input when input is accepted', () => {
      var mapper = new Mapper({ab: 'ab'});
      assertKeyMatch(mapper, "a", ['ab']);
      mapper.accept();
      assertKeyMatch(mapper, "a", ['ab']);
      assertKeyMatch(mapper, "a", []);
    });

    it('returns the full set of possibilities', () => {
      var mapper = new Mapper({ka: 'a', kb: 'b', ja: 'c'});
      mapper.keyPressed('k');
      var results = mapper.accept()
      assert.equal('a', results[0]);
      assert.equal('b', results[1]);
      assert.equal('c', results[2]);
      assert.equal(3, results.length);
    });
  });

  describe('.fromCodemirror', () => {
    it('converts uppercase letters to lowercase letters', () => {
      assert.equal(Mapper.fromCodemirror("M"), "m");
    });

    it('converts "SHIFT-" prefixed inputs to uppercase letters', () => {
      assert.equal(Mapper.fromCodemirror("SHIFT-M"), "M");
    });
  });
});
