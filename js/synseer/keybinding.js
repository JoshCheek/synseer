'use strict';

function Keybinding(attrs) {
  if(attrs.english) this.english = attrs.english;
  else throw(`No English name in ${JSON.stringify(attrs)}!`);

  if(attrs.keysequence) this.keysequence = attrs.keysequence;
  else throw(`No keysequence in ${JSON.stringify(attrs)}!`);

  if(attrs.data) this.data = attrs.data;
  else throw(`No data in ${JSON.stringify(attrs)}`);
}

Keybinding.prototype = {
  isGroup: false,

  hasData: function(data) {
    return this.data === data;
  },

  numChildren:      function() { return 0; },

  potentialMatches: function(keysPressed) {
    if(keysPressed.length > this.keysequence.length)
      return new Keybinding.Group();

    for(let i = 0; i < keysPressed.length; ++i)
      if(keysPressed[i] !== this.keysequence[i])
        return new Keybinding.Group();

    return this;
  },
}


Keybinding.groupFor = function(attrs) {
  return new Keybinding.Group(attrs);
}

Keybinding.Group = function(attrs) {
  attrs            = attrs             || {};
  this.english     = attrs.english     || "";
  this.keysequence = attrs.keysequence || "";
  this.keymap      = attrs.keymap      || [];
}

Keybinding.Group.prototype = {
  isGroup:          true,
  numChildren:      function() { return this.keymap.length; },
  potentialMatches: function(keysPressed) {
    let dup = []
    keysPressed.forEach(e => dup.push(e));
    for(let i=0; i<this.keysequence.length; ++i)
      if(this.keysequence[i] !== dup.shift())
        return new Keybinding.Group();

    let newKeymap = [];
    console.log('KEYMAP', JSON.stringify(this.keymap));
    this.keymap.forEach(kb => {
      let found = kb.potentialMatches(keysPressed);
      if(found.numChildren() !== 0) newKeymap.push(found);
    });

    return new Keybinding.Group({
      english:     this.english,
      keysequence: this.keysequence,
      keymap:      newKeymap,
    });
  },
}

module.exports = Keybinding;
