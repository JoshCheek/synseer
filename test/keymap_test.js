const  defaultKeybindings = require('../js/synseer/default_keybindings');
const  Mapper             = require('../js/synseer/key_mapper');
const  Keybinding         = require('../js/synseer/keybinding');
import assert from 'assert'; // https://github.com/joyent/node/blob/9010dd26529cea60b7ee55ddae12688f81a09fcb/lib/assert.js
import {readFile} from 'fs';
import {inspect} from 'util';

function kbWith(overrides) {
  const attrs = {keysequence: 'a', data: 'b', english: 'c'};
  Object.assign(attrs, overrides);
  return new Keybinding(attrs);
}

function keybindingsFor(pairs) {
  let keybindings = [];
  for(var seq in pairs) {
    keybindings.push(new Keybinding({ english: 'english', data: pairs[seq], keysequence: seq }));
  }
  return keybindings;
}

function mapperFor(pairs) {
  return new Mapper(keybindingsFor(pairs));
}


describe('Default keymap', ()=>{
  it('maps each of the keys', ()=>{
    const syntaxNodes = [
      "and", "arg", "args", "array", "begin", "block", "block_pass",
      "blockarg", "break", "case", "casgn", "class", "const", "def",
      "defs", "dstr", "ensure", "false", "gvar", "hash", "if", "int",
      "irange", "ivar", "ivasgn", "kwarg", "kwbegin", "kwoptarg", "lvar",
      "lvasgn", "masgn", "mlhs", "module", "next", "nil", "op_asgn", "optarg",
      "or", "or_asgn", "pair", "regexp", "regopt", "resbody", "rescue", "restarg",
      "return", "self", "send", "splat", "str", "super", "sym", "true", "until",
      "when", "while", "yield"
    ];
    const mapper = new Mapper(defaultKeybindings);
    syntaxNodes.forEach((nodeName) => {
      assert.equal(nodeName, mapper.findData(nodeName).data );
    });
  });
});

describe('A keybinding', () => {
  it('has an english representation, a keysequence, and some data the keysequence maps to', () => {
    const kb = new Keybinding({keysequence: "a",  data: "b",   english: 'c'});
    assert.equal("a", kb.keysequence);
    assert.equal("b", kb.data);
    assert.equal("c", kb.english);
  });

  it('explodes if not given any of these', () => {
    assert.doesNotThrow(() => new Keybinding({keysequence: "a",  data: "b", english: 'c'}));
    // tried asserting against what they throw, but it just passed when they threw strings...
    assert.throws(      () => new Keybinding({                   data: "b", english: 'c'}));
    assert.throws(      () => new Keybinding({keysequence: "a",             english: 'c'}));
    assert.throws(      () => new Keybinding({keysequence: "a",  data: "b"              }));
  });
});

describe('KeyMapper', ()=>{
  function assertKeyMatch(mapper, key, expecteds) {
    let expectedKbs = keybindingsFor(expecteds);
    let actualKbs   = mapper.keyPressed(key);
    let message     = `actual: ${inspect(actualKbs)} expected: ${inspect(expectedKbs)}`

    assert.equal(actualKbs.length, expectedKbs.length, message);

    for(let index in expectedKbs) {
      let expected = expectedKbs[index];
      let actual   = actualKbs[index];

      assert.equal(expected.data,        actual.data,        `${message}, but ${key} was actual:${actual}, expected:${expected}`);
      assert.equal(expected.english,     actual.english,     `${message}, but ${key} was actual:${actual}, expected:${expected}`);
      assert.equal(expected.keysequence, actual.keysequence, `${message}, but ${key} was actual:${actual}, expected:${expected}`);
    }
  }

  it('has a keybinding for each type of syntax that we use', (done)=>{
    readFile('tmp/node_types', 'utf8', (err, data) => {
      if(err) assert.fail(err);
      const mapper = new Mapper(defaultKeybindings);
      const types  = data.split("\n");
      if(types[types.length-1] === "") types.pop();
      types.forEach(type => mapper.findData(type)); // throws if it does not find
      done();
    });
  });

  it('throws an error on keymaps that cannot be uniquely entered', () => {
    assert.throws(       () => mapperFor({abc: "x",   ab:  "y"}));
    assert.doesNotThrow( () => mapperFor({abc: "x",   abd: "y"}) );
    assert.doesNotThrow( () => mapperFor({x:   "abc", y:   "ab"}) );
  });

  it('allows multiple keybindings to map to the same data', () => {
    assert.doesNotThrow(() => mapperFor({x: "result", y: "result"}));
  })

  describe('#findData', () => {
    it('can find data', () => {
      const keyMap = [new Keybinding({keysequence: "b",  data: "a",   english: 'b'})];
      const mapper = new Mapper(keyMap);
      assert.equal("b", mapper.findData("a").english);
    });

    it('throws an error when asked for data it does not have', () => {
      const keyMap = [new Keybinding({keysequence: "b",  data: "a", english: 'b'})];
      const mapper = new Mapper(keyMap);
      assert.throws(       () => mapper.findData("b"), Mapper.MissingDataError );
      assert.doesNotThrow( () => mapper.findData("a"));
    });
  });

  describe('.normalize', () => {
    it('converts uppercase letters to lowercase letters', () => {
      assert.equal(Mapper.normalize("M"), "m");
    });

    it('converts "SHIFT-" prefixed inputs to uppercase letters', () => {
      assert.equal(Mapper.normalize("SHIFT-M"), "M");
    });

    it('conversts "Esc" to "escape"', () => {
      assert.equal(Mapper.normalize("Esc"), "escape");
      assert.equal(Mapper.normalize("esc"), "escape");
    });
  });

  describe('#keyPressed', () => {
    it('maps a given key-sequence to the requested data', () => {
      let mapper = mapperFor({abc: "lol", def: "wtf"});
      assertKeyMatch(mapper, "d", {def: "wtf"});
    });

    it('remembers my input and gives me back a list of potential matches', ()=> {
      let mapper = mapperFor({and: "and", arg: "arg", ars: "args", array: "array", asgnor: "or_asgn", other: "other"});
      assertKeyMatch(mapper, "a", {and: "and", arg: "arg", ars: "args", array: "array", asgnor: "or_asgn"});
      assertKeyMatch(mapper, "r", {arg: "arg", ars: "args", array: "array"});
      assertKeyMatch(mapper, "r", {array: "array"});
    });

    it('backspace removes a character from the end of the input', ()=> {
      let mapper = mapperFor({and: "and", arg: "arg", ars: "args", array: "array", asgnor: "or_asgn", other: "other"});
      assertKeyMatch(mapper, "a",         {and: "and", arg: "arg", ars: "args", array: "array", asgnor: "or_asgn"});
      assertKeyMatch(mapper, "r",         {arg: "arg", ars: "args", array: "array"});
      assertKeyMatch(mapper, "backspace", {and: "and", arg: "arg", ars: "args", array: "array", asgnor: "or_asgn"});
    });

    it('clears the input when escape is pressed', ()=> {
      let map    = {aa: 'aa', aba: 'aba', abc: 'abc', b: 'b'};
      let mapper = mapperFor(map);
      assertKeyMatch(mapper, "a", {aa: 'aa', aba: 'aba', abc: 'abc'});
      assertKeyMatch(mapper, "b", {aba: 'aba', abc: 'abc'});

      assertKeyMatch(mapper, "escape", map);
    });

    it('ignores non-printable keypresses and tab and enter', () => {
      let mapper   = mapperFor({agood: "abc", ctrl: "ctrl"});
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
  });


  describe('#accept', () => {
    it('clears the input when input is accepted', () => {
      let mapper = mapperFor({ab: 'ab'});
      assertKeyMatch(mapper, "a", {ab: 'ab'});
      mapper.accept();
      assertKeyMatch(mapper, "a", {ab: 'ab'});
      assertKeyMatch(mapper, "a", {});
    });

    it('returns the full set of possibilities', () => {
      let mapper = mapperFor({ka: 'a', kb: 'b', ja: 'c'});
      mapper.keyPressed('k');
      let results = mapper.accept()
      assert.equal('a', results[0].data);
      assert.equal('b', results[1].data);
      assert.equal('c', results[2].data);
      assert.equal(3, results.length);
    });

    it('normalizes the input', () => {
      let mapper = mapperFor({ka: 'a', kb: 'b', ja: 'c'});
      let results = mapper.keyPressed('k');
      assert.equal(2, results.length);
      results = mapper.keyPressed('Esc');
      assert.equal(3, results.length);
    });
  });
});
