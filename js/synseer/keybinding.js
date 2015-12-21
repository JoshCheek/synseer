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
  isGroup:    false,

  isSequence: function(sequence) {
    return this.keysequence == sequence;
  },

  hasData: function(data) {
    return this.data === data;
  },

  potentialMatches: function(keysPressed, startIndex) {
    // not equal if they pressed more keys than we have
    let pg = new Keybinding.PseudoGroup({keymap: []});

    if(keysPressed.length > this.keysequence.length+startIndex)
      return pg;

    for(let i = 0; i+startIndex < keysPressed.length; ++i)
      if(this.keysequence[i] !== keysPressed[startIndex+i])
        return pg;

    pg.push(this);
    return pg;
  },
}



Keybinding.groupFor = function(attrs) {
  return new Keybinding.Group(attrs);
}

Keybinding.PseudoGroup = function(attrs) {
  attrs.keymap.forEach(kb => this.push(kb));
}

// Inherit from array so that we are a legitimate collection
Keybinding.PseudoGroup.prototype = proto => {
  proto.isGroup          = true;
  proto.english          = "";
  proto.keysequence      = "";
  proto.potentialMatches = function(keysPressed, startIndex) {
    let filtered = [];
    this.forEach(kb => {
      let potentials = kb.potentialMatches(keysPressed, startIndex);
      if(potentials.isGroup && potentials.length > 0) {
        filtered.push(potentials);
      } else {
        potentials.forEach(p => filtered.push(p));
      }
    });

    if(filtered.length === 1) return filtered[0];
    return new Keybinding.PseudoGroup({keymap: filtered});
  };

  proto.constructor = Keybinding.PseudoGroup;
  return proto;
}([]);



Keybinding.Group = function(attrs) {
  this.keysequence = attrs.keysequence;
  this.english     = attrs.english || "";
  attrs.keymap.forEach(kb => this.push(kb));
}
Keybinding.Group.prototype = proto => {
  proto.isGroup          = true;
  proto.potentialMatches = function(keysPressed, startIndex) {
    let filtered = new Keybinding.PseudoGroup({keymap: []});

    // consume out characters from the keysPressed
    let inBounds = i => i < this.keysequence.length &&
                        i + startIndex < keysPressed.length;

    for(let i = 0; inBounds(i); ++i)
      if(this.keysequence[i] !== keysPressed[startIndex+i])
        return filtered;

    // return an array of all the children who match what remains
    this.forEach(kb => {
      let potentials = kb.potentialMatches(keysPressed, startIndex+this.keysequence.length)
      if(potentials.isGroup && potentials.length > 0) {
        filtered.push(potentials);
      } else {
        potentials.forEach(p => filtered.push(p));
      }
    });

    if(filtered.length === 1) return filtered[0];
    return filtered;
  };

  proto.constructor = Keybinding.Group;
  return proto;
}([]);


module.exports = Keybinding;
