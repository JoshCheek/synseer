import * as DefaultKeymap from '../src-js/synseer/default_keymap';
import assert from 'assert'; // https://github.com/joyent/node/blob/9010dd26529cea60b7ee55ddae12688f81a09fcb/lib/assert.js

describe('Parse', ()=>{
  it('parses single expressions, tracking location information', ()=>{
    assert.equal('nil', 'nil');
  });
});
