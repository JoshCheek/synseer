import * as DefaultKeymap from '../js/synseer/default_keymap';
import assert from 'assert'; // https://github.com/joyent/node/blob/9010dd26529cea60b7ee55ddae12688f81a09fcb/lib/assert.js
import {readFile} from 'fs';

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

  // skipping b/c there's enough different types, that single-letters aren't going to cut it
  xit('has a keybinding for each type of syntax that we use', (done)=>{
    readFile('tmp/node_types', 'utf8', (err, data) => {
      if(err) assert.fail(err);
      var types = data.split("\n");
      if(types[types.length-1] === "")
        types.pop();
      var keys   = Object.keys(DefaultKeymap);
      var values = [];
      for(var i = 0; i < keys.length; ++i) {
        values.push(DefaultKeymap[keys[i]]);
      }
      for(var i = 0; i < types.length; ++i) {
        var type = types[i];
        if(-1 == values.indexOf(type))
          assert.fail(`No keybinding for ${type}`)
      }
      done();
    });
  });
});
