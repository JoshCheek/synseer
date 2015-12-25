"use strict";

const  Keybinding         = require('../js/synseer/keybinding');
const  defaultKeybindings = require('../js/synseer/default_keybindings');
const  Mapper             = require('../js/synseer/key_mapper');
import assert from 'assert'; // https://github.com/joyent/node/blob/9010dd26529cea60b7ee55ddae12688f81a09fcb/lib/assert.js
import {readFile} from 'fs';
import {inspect} from 'util';

let bindingFor = Keybinding.for;
let groupFor = Keybinding.Group.for;

function mapperFor(pairs) {
  return new Mapper(keybindingsFor(pairs));
}

function clear(mapper) {
  mapper.keyPressed('escape');
}

describe('Default keymap', ()=>{
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
});

describe('A keybinding', () => {
  it('has an english representation, a key, and some data the key maps to', () => {
    const kb = bindingFor('b', 'a', 'c')
    assert.equal("a", kb.key);
    assert.equal("b", kb.data);
    assert.equal("c", kb.english);
  });
});

describe('KeyMapper', ()=>{
  function assertKeyMatch(mapper, key, expecteds) {
    let expectedKbs = keybindingsFor(expecteds);
    mapper.keyPressed(key);
    let actualKbs = mapper.possibilities();
    assert.equal(JSON.stringify(actualKbs), JSON.stringify(expectedKbs));
  }

  describe('#findData', () => {
    let keymap = groupFor('english', '', [
                   groupFor('en', 'a', [
                     bindingFor('c', 'b', 'en'),
                     bindingFor('e', 'd', 'en')]),
                   groupFor('en', 'f', [
                     bindingFor('h', 'g', 'en'),
                     groupFor('en', 'i', [
                       bindingFor('k', 'j', 'en'),
                       bindingFor('m', 'l', 'en')]),
                     groupFor('en', '', [
                       bindingFor('o', 'n', 'en'),
                       bindingFor('q', 'p', 'en')])])]);
    let mapper = new Mapper(keymap);

    it('can find data', () => {
      assert.equal(mapper.findData("c").key, "b");
      assert.equal(mapper.findData("e").key, "d");
      assert.equal(mapper.findData("h").key, "g");
      assert.equal(mapper.findData("k").key, "j");
      assert.equal(mapper.findData("m").key, "l");
      assert.equal(mapper.findData("o").key, "n");
      assert.equal(mapper.findData("q").key, "p");
    });

    it('returns nil when asked for data it does not have', () => {
      assert.equal(null, mapper.findData('zz'));
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
      let keymap = groupFor('english', '', [
                     bindingFor('lol', 'abc', 'abc -> lol'),
                     bindingFor('wtf', 'def', 'def -> wtf')]);
      let mapper = new Mapper(keymap);
      mapper.keyPressed("d");
      assert.deepEqual(["wtf"], mapper.potentials().children.map(kb => kb.data));
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

    it('allows keybindings to be nested', () => {
      let mapper = mapperFor({
        a: {b: 'c', d: 'e'},
        f: {g: 'h', i: {j: 'k', l: 'm'}},
      });

      // no groups
      assertKeyMatch(mapper, "a", {b: 'c', d: 'e'});
      assertKeyMatch(mapper, "b", {b: 'c'});
      clear(mapper);
      assertKeyMatch(mapper, "f", {g: 'h', i: {j: 'k', l: 'm'}});
      assertKeyMatch(mapper, "i", {j: 'k', l: 'm'});
      assertKeyMatch(mapper, "j", {j: 'k'});
      clear(mapper);
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
    it('normalizes the input', () => {
      let mapper = mapperFor({ka: 'a', kb: 'b', ja: 'c'});
      let results = mapper.keyPressed('k');
      assert.equal(2, results.length);
      results = mapper.keyPressed('Esc'); // "Esc" works, so it was normalized to "escape"
      assert.equal(3, results.length);
    });
  });

  describe('#possibilities', () => {
    it('finds keys pressed in groups that have no keybindings', () => {
      let mapper = mapperFor({
        a: 'b',
        '': {b: 'c', d: 'e'},
        f: {g: 'h', i: {j: 'k', l: 'm'}},
      });

      assertKeyMatch(mapper, '', {
        a: 'b',
        '': {b: 'c', d: 'e'},
        f: {g: 'h', i: {j: 'k', l: 'm'}},
      });
      assertKeyMatch(mapper, 'a', {a: 'b'});
      clear(mapper);

      assertKeyMatch(mapper, 'f', { g: 'h', i: {j: 'k', l: 'm'}});
      assertKeyMatch(mapper, 'i', {j: 'k', l: 'm'});
      assertKeyMatch(mapper, 'j', {j: 'k'});
      clear(mapper);

      assertKeyMatch(mapper, 'j', {j: 'k'});
      clear(mapper);
    });
  });
});
