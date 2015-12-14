const map    = require('../js/synseer/default_keymap');
const Mapper = require('../js/synseer/key_mapper');
import assert from 'assert'; // https://github.com/joyent/node/blob/9010dd26529cea60b7ee55ddae12688f81a09fcb/lib/assert.js
import {readFile} from 'fs';
import {inspect} from 'util';

describe('KeyMapper', ()=>{
  it('maps each of the keys', ()=>{
    assert.equal("and"        , map.ca);
    assert.equal("arg"        , map.ag);
    assert.equal("args"       , map.as);
    assert.equal("array"      , map.la);
    assert.equal("begin"      , map.b);
    assert.equal("block"      , map.abl);
    assert.equal("block_pass" , map.abp);
    assert.equal("blockarg"   , map.aba);
    assert.equal("break"      , map.cbr);
    assert.equal("case"       , map.cca);
    assert.equal("casgn"      , map.sc);
    assert.equal("class"      , map.oc);
    assert.equal("const"      , map.gc);
    assert.equal("def"        , map.odf);
    assert.equal("defs"       , map.ods);
    assert.equal("dstr"       , map.ld);
    assert.equal("ensure"     , map.ce);
    assert.equal("false"      , map.lf);
    assert.equal("gvar"       , map.gg);
    assert.equal("hash"       , map.lh);
    assert.equal("if"         , map.ci);
    assert.equal("int"        , map.li);
    assert.equal("irange"     , map.ir);
    assert.equal("ivar"       , map.gi);
    assert.equal("ivasgn"     , map.si);
    assert.equal("kwarg"      , map.ak);
    assert.equal("kwbegin"    , map.cbe);
    assert.equal("kwoptarg"   , map.aok);
    assert.equal("lvar"       , map.gl);
    assert.equal("lvasgn"     , map.sl);
    assert.equal("masgn"      , map.sm);
    assert.equal("mlhs"       , map.mlhs);
    assert.equal("module"     , map.om);
    assert.equal("next"       , map.cn);
    assert.equal("nil"        , map.ln);
    assert.equal("op_asgn"    , map.sop);
    assert.equal("optarg"     , map.aog);
    assert.equal("or"         , map.co);
    assert.equal("or_asgn"    , map.sor);
    assert.equal("pair"       , map.p);
    assert.equal("regexp"     , map.lr);
    assert.equal("regopt"     , map.lo);
    assert.equal("resbody"    , map.crb);
    assert.equal("rescue"     , map.crs);
    assert.equal("restarg"    , map.cra);
    assert.equal("return"     , map.cre);
    assert.equal("self"       , map.os);
    assert.equal("send"       , map.ms);
    assert.equal("splat"      , map.sp);
    assert.equal("str"        , map.ls);
    assert.equal("super"      , map.cs);
    assert.equal("sym"        , map.ly);
    assert.equal("true"       , map.lt);
    assert.equal("until"      , map.cu);
    assert.equal("when"       , map.ccw);
    assert.equal("while"      , map.cw);
    assert.equal("yield"      , map.cy);
  });

  function assertKeyMatch(mapper, key, expected) {
    var actual = mapper.keyPressed(key);
    let message = `Expected ${inspect(actual)} to be like ${inspect(expected)}`
    assert.equal(Object.keys(actual).length, Object.keys(expected).length, message);
    for(var key in expected) {
      assert.equal(actual[key], expected[key], `${message}, but ${key} was actual:${actual[key]}, expected:${expected[key]}`);
    }
  }

  it('remembers my input and gives me back a list of potential matches', ()=> {
    var mapper = new Mapper({and: "and", arg: "arg", ars: "args", array: "array", asgnor: "or_asgn", other: "other"});
    assertKeyMatch(mapper, "a", {and: "and", arg: "arg", ars: "args", array: "array", asgnor: "or_asgn"});
    assertKeyMatch(mapper, "r", {arg: "arg", ars: "args", array: "array"});
    assertKeyMatch(mapper, "r", {array: "array"});
  });

  it('backspace removes a character from the end of the input', ()=> {
    var mapper = new Mapper({and: "and", arg: "arg", ars: "args", array: "array", asgnor: "or_asgn", other: "other"});
    assertKeyMatch(mapper, "a",         {and: "and", arg: "arg", ars: "args", array: "array", asgnor: "or_asgn"});
    assertKeyMatch(mapper, "r",         {arg: "arg", ars: "args", array: "array"});
    assertKeyMatch(mapper, "backspace", {and: "and", arg: "arg", ars: "args", array: "array", asgnor: "or_asgn"});
  });

  it('clears the input when escape is pressed', ()=> {
    var map    = {aa: 'aa', aba: 'aba', abc: 'abc', b: 'b'};
    var mapper = new Mapper(map);
    assertKeyMatch(mapper, "a", {aa: 'aa', aba: 'aba', abc: 'abc'});
    assertKeyMatch(mapper, "b", {aba: 'aba', abc: 'abc'});

    assertKeyMatch(mapper, "escape", map);
  });

  it('ignores non-printable keypresses and tab and enter', () => {
    let mapper   = new Mapper({agood: "abc", ctrl: "ctrl"});
    let expected = {agood: 'abc'};
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

  it('throws an error on keymaps that cannot be uniquely entered', () => {
    assert.throws(       () => new Mapper({abc: "x",   ab:  "y"}), Mapper.KeyConflictError );
    assert.doesNotThrow( () => new Mapper({abc: "x",   abd: "y"}) );
    assert.doesNotThrow( () => new Mapper({x:   "abc", y:   "ab"}) );
  });

  it('allows multiple keybindings to map to the same key', () => {
    assert.doesNotThrow(() => new Mapper({x: "result", y: "result"}));
  })

  it('maps a given key-sequence to the requested key', () => {
    var mapper = new Mapper({abc: "lol", def: "wtf"});
    assertKeyMatch(mapper, "d", {def: "wtf"});
  });

  describe('#accept', () => {
    it('clears the input when input is accepted', () => {
      var mapper = new Mapper({ab: 'ab'});
      assertKeyMatch(mapper, "a", {ab: 'ab'});
      mapper.accept();
      assertKeyMatch(mapper, "a", {ab: 'ab'});
      assertKeyMatch(mapper, "a", {});
    });

    it('returns the full set of possibilities', () => {
      var mapper = new Mapper({ka: 'a', kb: 'b', ja: 'c'});
      mapper.keyPressed('k');
      var results = mapper.accept()
      assert.equal('a', results.ka);
      assert.equal('b', results.kb);
      assert.equal('c', results.ja);
      assert.equal(3, Object.keys(results).length);
    });
  });

  describe('.fromCodemirror', () => {
    it('converts uppercase letters to lowercase letters', () => {
      assert.equal(Mapper.fromCodemirror("M"), "m");
    });

    it('converts "SHIFT-" prefixed inputs to uppercase letters', () => {
      assert.equal(Mapper.fromCodemirror("SHIFT-M"), "M");
    });

    it('conversts "Esc" to "escape"', () => {
      assert.equal(Mapper.fromCodemirror("Esc"), "escape");
      assert.equal(Mapper.fromCodemirror("esc"), "escape");
    });
  });
});
