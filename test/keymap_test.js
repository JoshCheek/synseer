"use strict";

const Keybinding         = require('../js/synseer/keybinding');
const defaultKeybindings = require('../js/synseer/default_keybindings');
const Mapper             = require('../js/synseer/key_mapper');
const assert             = require('assert'); // https://github.com/joyent/node/blob/9010dd26529cea60b7ee55ddae12688f81a09fcb/lib/assert.js
const readFile           = require('fs').readFile;
const inspect            = require('util').inspect;

let bindingFor = Keybinding.for;
let groupFor = Keybinding.Group.for;

function mapperFor(pairs) {
  return new Mapper(bindingFor(pairs));
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
    let expectedKbs = bindingFor(expecteds);
    mapper.keyPressed(key);
    let actualKbs = mapper.potentials();
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

    it('converts shift-number to the fancy character', () => {
      assert.equal(Mapper.normalize("`"),       "`");
      assert.equal(Mapper.normalize("shift-`"), "~");

      assert.equal(Mapper.normalize("1"),       "1");
      assert.equal(Mapper.normalize("shift-1"), "!");

      assert.equal(Mapper.normalize("2"),       "2");
      assert.equal(Mapper.normalize("shift-2"), "@");

      assert.equal(Mapper.normalize("3"),       "3");
      assert.equal(Mapper.normalize("shift-3"), "#");

      assert.equal(Mapper.normalize("4"),       "4");
      assert.equal(Mapper.normalize("shift-4"), "$");

      assert.equal(Mapper.normalize("5"),       "5");
      assert.equal(Mapper.normalize("shift-5"), "%");

      assert.equal(Mapper.normalize("6"),       "6");
      assert.equal(Mapper.normalize("shift-6"), "^");

      assert.equal(Mapper.normalize("7"),       "7");
      assert.equal(Mapper.normalize("shift-7"), "&");

      assert.equal(Mapper.normalize("8"),       "8");
      assert.equal(Mapper.normalize("shift-8"), "*");

      assert.equal(Mapper.normalize("9"),       "9");
      assert.equal(Mapper.normalize("shift-9"), "(");

      assert.equal(Mapper.normalize("0"),       "0");
      assert.equal(Mapper.normalize("shift-0"), ")");

      assert.equal(Mapper.normalize("-"),       "-");
      assert.equal(Mapper.normalize("shift--"), "_");

      assert.equal(Mapper.normalize("="),       "=");
      assert.equal(Mapper.normalize("shift-="), "+");

      assert.equal(Mapper.normalize("["),       "[");
      assert.equal(Mapper.normalize("shift-["), "{");

      assert.equal(Mapper.normalize("]"),       "]");
      assert.equal(Mapper.normalize("shift-]"), "}");

      assert.equal(Mapper.normalize("\\"),       "\\");
      assert.equal(Mapper.normalize("shift-\\"), "|");

      assert.equal(Mapper.normalize(";"),       ";");
      assert.equal(Mapper.normalize("shift-;"), ":");

      assert.equal(Mapper.normalize("'"),       "'");
      assert.equal(Mapper.normalize("shift-'"), "\"");

      assert.equal(Mapper.normalize(","),       ",");
      assert.equal(Mapper.normalize("shift-,"), "<");

      assert.equal(Mapper.normalize("."),       ".");
      assert.equal(Mapper.normalize("shift-."), ">");

      assert.equal(Mapper.normalize("/"),       "/");
      assert.equal(Mapper.normalize("shift-/"), "?");
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
      let keymap = groupFor('english', '', [
        bindingFor('and',     'and',    'and'),
        bindingFor('arg',     'arg',    'arg'),
        bindingFor('args',    'ars',    'args'),
        bindingFor('array',   'array',  'array'),
        bindingFor('or_asgn', 'asgnor', 'or_asgn'),
        bindingFor('other',   'other',  'other'),
      ]);
      let mapper = new Mapper(keymap);
      mapper.keyPressed("a");
      assert.deepEqual(["and", "arg", "args", "array", "or_asgn"], mapper.potentials().children.map(kb => kb.data));

      mapper.keyPressed("r");
      assert.deepEqual(["arg", "args", "array"], mapper.potentials().children.map(kb => kb.data));

      mapper.keyPressed("r");
      assert.deepEqual(["array"], mapper.potentials().children.map(kb => kb.data));
    });

    it('backspace removes a character from the end of the input', ()=> {
      let keymap = groupFor('english', '', [
        bindingFor('and',     'and',    'and'),
        bindingFor('arg',     'arg',    'arg'),
        bindingFor('args',    'ars',    'args'),
        bindingFor('array',   'array',  'array'),
        bindingFor('or_asgn', 'asgnor', 'or_asgn'),
        bindingFor('other',   'other',  'other'),
      ]);
      let mapper = new Mapper(keymap);
      mapper.keyPressed("a");
      assert.deepEqual(["and", "arg", "args", "array", "or_asgn"], mapper.potentials().children.map(kb => kb.data));

      mapper.keyPressed("r");
      assert.deepEqual(["arg", "args", "array"], mapper.potentials().children.map(kb => kb.data));

      mapper.keyPressed("backspace");
      assert.deepEqual(["and", "arg", "args", "array", "or_asgn"], mapper.potentials().children.map(kb => kb.data));
    });

    it('clears the input when escape is pressed', ()=> {
      let keymap = groupFor('english', '', [
        bindingFor('aa',  'aa',  'aa'),
        bindingFor('aba', 'aba', 'aba'),
        bindingFor('abc', 'abc', 'abc'),
        bindingFor('b',   'b',   'b'),
      ]);
      let mapper = new Mapper(keymap);

      mapper.keyPressed("a");
      assert.deepEqual(["aa", "aba", "abc"], mapper.potentials().children.map(kb => kb.data));

      mapper.keyPressed("b");
      assert.deepEqual(["aba", "abc"], mapper.potentials().children.map(kb => kb.data));

      mapper.keyPressed("escape");
      assert.deepEqual(['aa', 'aba', 'abc', 'b'], mapper.potentials().children.map(kb => kb.data));
    });

    it('ignores non-printable keypresses and tab and enter', () => {
      let keymap = groupFor('english', '', [
        bindingFor('agood', 'agood', 'agood'),
        bindingFor('ctrl',  'ctrl',  'ctrl'),
      ]);
      let mapper = new Mapper(keymap);
      let expected = ['agood']

      mapper.keyPressed("a");
      assert.deepEqual(expected, mapper.potentials().children.map(kb => kb.data));

      mapper.keyPressed("alt");
      assert.deepEqual(expected, mapper.potentials().children.map(kb => kb.data));

      mapper.keyPressed("cmd-alt-mod");
      assert.deepEqual(expected, mapper.potentials().children.map(kb => kb.data));

      mapper.keyPressed("cmd-ctrl-alt-mod");
      assert.deepEqual(expected, mapper.potentials().children.map(kb => kb.data));

      mapper.keyPressed("cmd-ctrl-mod");
      assert.deepEqual(expected, mapper.potentials().children.map(kb => kb.data));

      mapper.keyPressed("cmd-mod");
      assert.deepEqual(expected, mapper.potentials().children.map(kb => kb.data));

      mapper.keyPressed("ctrl");
      assert.deepEqual(expected, mapper.potentials().children.map(kb => kb.data));

      mapper.keyPressed("ctrl-alt");
      assert.deepEqual(expected, mapper.potentials().children.map(kb => kb.data));

      mapper.keyPressed("enter");
      assert.deepEqual(expected, mapper.potentials().children.map(kb => kb.data));

      mapper.keyPressed("shift-alt");
      assert.deepEqual(expected, mapper.potentials().children.map(kb => kb.data));

      mapper.keyPressed("shift-cmd-ctrl-alt-mod");
      assert.deepEqual(expected, mapper.potentials().children.map(kb => kb.data));

      mapper.keyPressed("shift-cmd-ctrl-mod");
      assert.deepEqual(expected, mapper.potentials().children.map(kb => kb.data));

      mapper.keyPressed("shift-cmd-mod");
      assert.deepEqual(expected, mapper.potentials().children.map(kb => kb.data));

      mapper.keyPressed("shift-ctrl-alt");
      assert.deepEqual(expected, mapper.potentials().children.map(kb => kb.data));

      mapper.keyPressed("shift-ctrl-shift");
      assert.deepEqual(expected, mapper.potentials().children.map(kb => kb.data));

      mapper.keyPressed("shift-shift");
      assert.deepEqual(expected, mapper.potentials().children.map(kb => kb.data));

      mapper.keyPressed("space");
      assert.deepEqual(expected, mapper.potentials().children.map(kb => kb.data));

      mapper.keyPressed("tab");
      assert.deepEqual(expected, mapper.potentials().children.map(kb => kb.data));


      mapper.keyPressed("down");
      assert.deepEqual(expected, mapper.potentials().children.map(kb => kb.data));

      mapper.keyPressed("left");
      assert.deepEqual(expected, mapper.potentials().children.map(kb => kb.data));

      mapper.keyPressed("right");
      assert.deepEqual(expected, mapper.potentials().children.map(kb => kb.data));

      mapper.keyPressed("up");
      assert.deepEqual(expected, mapper.potentials().children.map(kb => kb.data));
    });

    it('allows keybindings to be nested', () => {
      let keymap = groupFor('english', '', [
        groupFor('a', 'a', [
          bindingFor('c', 'b', 'b->c'),
          bindingFor('e', 'd', 'd->e'),
        ]),
        groupFor('f', 'f', [
          bindingFor('h', 'g', 'h->g'),
          groupFor('i', 'i', [
            bindingFor('k', 'j', 'j->k'),
            bindingFor('m', 'l', 'l->m'),
          ]),
        ]),
      ]);
      let mapper = new Mapper(keymap);

      // no groups
      mapper.keyPressed("a");
      mapper.potentials();
      assert.deepEqual(['c', 'e'], mapper.potentials().children.map(kb => kb.data));

      mapper.keyPressed("b");
      assert.deepEqual(['c'], mapper.potentials().children.map(kb => kb.data));
      mapper.keyPressed('escape');

      // with groups
      mapper.keyPressed("f");
      assert.equal('h', mapper.potentials().children[0].data);
      assert.deepEqual(['k', 'm'], mapper.potentials().children[1].children.map(kb => kb.data));

      mapper.keyPressed("i");
      assert.deepEqual(['k', 'm'], mapper.potentials().children.map(kb => kb.data));

      mapper.keyPressed("j");
      assert.deepEqual(['k'], mapper.potentials().children.map(kb => kb.data));
    });
  });


  describe('#accept', () => {
    it('clears the input when input is accepted', () => {
      let mapper = new Mapper(groupFor('english', '', [
        groupFor('a', 'a', [bindingFor('b', 'b', 'b->b')])
      ]));

      mapper.keyPressed('a');
      assert.deepEqual(['b'], mapper.potentials().children.map(kb => kb.data));

      mapper.accept();
      assert.equal('a', mapper.potentials().name);
    });

    it('normalizes the input', () => {
      let mapper = new Mapper(groupFor('english', '', [
        bindingFor('a', 'ka', 'a->ka'),
        bindingFor('b', 'kb', 'b->kb'),
        bindingFor('c', 'jc', 'c->kc'),
      ]));
      mapper.keyPressed('k');
      assert.equal(2, mapper.potentials().children.length);
      mapper.keyPressed('Esc'); // "Esc" works, so it was normalized to "escape"
      assert.equal(3, mapper.potentials().children.length);
    });
  });

  describe('#possibilities', () => {
    it('finds keys pressed in groups that have no keybindings', () => {
      var potentials = null;
      let mapper = new Mapper(groupFor('english', '', [
        bindingFor('b', 'a', 'a->b'),
        groupFor('', '', [
          bindingFor('c', 'b', 'b->c'),
          bindingFor('e', 'd', 'd->e'),
        ]),
        groupFor('f', 'f', [
          bindingFor('h', 'g', 'g->h'),
          groupFor('i', 'i', [
            bindingFor('k', 'j', 'j->k'),
            bindingFor('m', 'l', 'l->m'),
          ])
        ]),
      ]));


      mapper.keyPressed('a');
      assert.deepEqual(['b'], mapper.potentials().children.map(kb => kb.data));
      clear(mapper);

      mapper.keyPressed('f');
      potentials = mapper.potentials().children;
      assert.equal('g->h', potentials[0].english);
      assert.equal('i',    potentials[1].name);

      mapper.keyPressed('i');
      potentials = mapper.potentials().children;
      assert.equal('j->k', potentials[0].english);
      assert.equal('l->m', potentials[1].english);

      mapper.keyPressed('j');
      potentials = mapper.potentials().children;
      assert.equal('j->k', potentials[0].english);
      assert.equal(1,      potentials.length);
      clear(mapper);

      mapper.keyPressed('b');
      potentials = mapper.potentials().children;
      assert.equal('b->c', potentials[0].english);
      assert.equal(1,      potentials.length);
      clear(mapper);
    });
  });
});
