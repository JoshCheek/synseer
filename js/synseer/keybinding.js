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
  },

  root: function() { return this; },

  potentialMatches: function(keysPressed, startIndex) {
    // console.log({
    //   keysPressed: keysPressed,
    //   startIndex: startIndex,
    //   keysequence: this.keysequence,
    //   startIndexAndLen: this.keysequence.length+startIndex,
    //   kp_len: keysPressed.length,
    // });

    // not equal if they pressed more keys than we have
    if(keysPressed.length > this.keysequence.length+startIndex) {
      // console.log("RETURNING [] -- pressed too many keys");
      return [];
    }

    for(let i = 0; i+startIndex < keysPressed.length; ++i) {
      if(this.keysequence[i] !== keysPressed[startIndex+i]) {
        // console.log(`RETURNING [] -- no match: ${this.keysequence}[${i}] !== ${keysPressed}[${startIndex+i}]`);
        return [];
      }
    }

    return [this];
  },
}



Keybinding.groupFor = function(attrs) {
  let hasSeq = attrs.keysequence === '' ||
               attrs.keysequence === undefined;
  return new (hasSeq ? Keybinding.PseudoGroup : Keybinding.Group)(attrs);
}

function groupRoot(group) {
  if(group.length === 1) return group[0];
  return group;
}

Keybinding.PseudoGroup = function(attrs) {
  this.english = attrs.english;
  attrs.keymap.forEach(kb => this.push(kb));
}

// Inherit from array so that we are a legitimate collection
Keybinding.PseudoGroup.prototype = proto => {
  proto.isGroup          = true;
  proto.isPseudoGroup    = true
  proto.keysequence      = "";
  proto.root             = function() { return groupRoot(this) };
  proto.potentialMatches = function(keysPressed, startIndex) {
    let filtered = [];
    this.forEach(kb => {
      kb.potentialMatches(keysPressed, startIndex)
        .forEach(childKb => filtered.push(childKb));
    });
    if(filtered.length === 0) return [];
    return new Keybinding.PseudoGroup({english: this.english, keymap: filtered});
  };

  proto.constructor = Keybinding.PseudoGroup;
  return proto;
}([]);



Keybinding.Group = function(attrs) {
  this.keysequence = attrs.keysequence;
  this.english     = attrs.english;
  attrs.keymap.forEach(kb => this.push(kb));
}
Keybinding.Group.prototype = proto => {
  proto.isGroup          = true;
  proto.isPseudoGroup    = false;
  proto.root             = function() { return groupRoot(this) };
  proto.potentialMatches = function(keysPressed, startIndex) {
    // consume out characters from the keysPressed
    let inBounds = i => i < this.keysequence.length &&
                        i + startIndex < keysPressed.length;

    for(let i = 0; inBounds(i); ++i)
      if(this.keysequence[i] !== keysPressed[startIndex+i])
        return [];

    // return an array of all the children who match what remains
    let filtered = [];
    this.forEach(kb => {
      kb.potentialMatches(keysPressed, startIndex+this.keysequence.length)
        .forEach(kb => filtered.push(kb));
    });
    if(filtered.length === 0) return [];
    return new Keybinding.Group({
      keysequence: this.keysequence,
      english:     this.english,
      keymap:      filtered,
    });
  };

  proto.constructor = Keybinding.Group;
  return proto;
}([]);


module.exports = Keybinding;
