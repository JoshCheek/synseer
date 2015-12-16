'use strict';

function Keybinding(attrs) {
  if(attrs.english) this.english = attrs.english;
  else throw(`No English name in ${attrs}!`);

  if(attrs.keysequence) this.keysequence = attrs.keysequence;
  else throw(`No keysequence in ${attrs}!`);

  if(attrs.data) this.data = attrs.data;
  else throw(`No data in ${attrs}`);
}

Keybinding.prototype = {
  isSequence: function(sequence) {
    return this.keysequence == sequence;
  },

  hasData: function(data) {
    return this.data === data;
  }
}

module.exports = Keybinding;
