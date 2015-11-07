import * as DefaultKeymap from '../src-js/synseer/default_keymap';
import assert from 'assert'; // https://github.com/joyent/node/blob/9010dd26529cea60b7ee55ddae12688f81a09fcb/lib/assert.js

describe('DefaultKeymap', ()=>{
  it('maps each of the keys', ()=>{
    assert.equal(DefaultKeymap.M,          "send");
    assert.equal(DefaultKeymap.I,          "int");
    assert.equal(DefaultKeymap.A,          "array");
    assert.equal(DefaultKeymap.B,          "begin");
    assert.equal(DefaultKeymap.F,          "if");
    assert.equal(DefaultKeymap.L,          "lvar");
    assert.equal(DefaultKeymap["Shift-L"], "lvasgn");
    assert.equal(DefaultKeymap["Shift-O"], "op_asgn");
    assert.equal(DefaultKeymap.S,          "str");
    assert.equal(DefaultKeymap.W,          "while");
  });

  it('has a keybinding for each type of syntax that we use');
});
