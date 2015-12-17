'use strict';

let KeyMapper = function(keymap) {
  this.keymap = keymap;
  this.keysPressed = [];
  KeyMapper.validateMap(keymap);
}


KeyMapper.KeyConflictError = function(conflictingKeys) {
  this.conflictingKeys = conflictingKeys;
  this.name            = 'KeyConflictError';
  let conflictStr      = conflictingKeys.map(([key, child]) => `[${key.english}, ${child.english}]`).join(", ")
  this.message         = `Conflicts: ${conflictStr}`;
}
KeyMapper.KeyConflictError.prototype = new Error();
KeyMapper.KeyConflictError.prototype.constructor = KeyMapper.KeyConflictError;


KeyMapper.normalize = function(key) {
  key = key.toLowerCase();
  if(key === 'esc') return 'escape';

  let match = (/^shift-(.+)/).exec(key);
  if(match) return match[1].toUpperCase();
  return key;
}

// http://www.sitepoint.com/exceptional-exception-handling-in-javascript/
KeyMapper.validateMap = function(keymap) {
  function flatten(km) {
    const expanded = [];
    km.forEach(kb => {
      if(kb.isPseudoGroup)
        flatten(kb.keymap).forEach(kb => expanded.push(kb));
      else
        expanded.push(kb)
    });
    return expanded;
  }

  const conflictingKeys = [];

  keymap = flatten(keymap);
  keymap.forEach((keybinding) => {
    keymap.forEach((maybeChild) => {
      const parentKb = keybinding.keysequence;
      const childKb  = maybeChild.keysequence;
      // if length is less, then it can't be a child
      // if length is the same, then it either is keybinding, or takes a different path
      if(childKb.length <= parentKb.length) return;
      let otherSubstr = childKb.substr(0, parentKb.length)
      if(otherSubstr === parentKb)
        conflictingKeys.push([keybinding, maybeChild]);

      [parentKb, childKb].forEach(kb => {
        if(kb.isGroup && !kb.isPseudoGroup)
          KeyMapper.validateMap(kb.keymap);
      });
    });
  });
  if(conflictingKeys.length > 0)
    throw new KeyMapper.KeyConflictError(conflictingKeys);
}

KeyMapper.prototype = {
  accept: function() {
    this.keysPressed = [];
    return this.possibilities();
  },

  input: function() {
    return this.keysPressed.join('');
  },

  keyPressed: function(input) {
    input = KeyMapper.normalize(input);

    if(input=="backspace") {
      this.keysPressed.pop();
    } else if(input == "escape") {
      this.keysPressed = [];
    } else if(!(/^[a-zA-Z]$/).exec(input)) {
      // noop on meta keys
    } else {
      this.keysPressed.push(input);
    }
    return this.possibilities();
  },

  startsWith: function(string, fragment) {
    return fragment == string.substring(0, fragment.length);
  },

  possibilities: function() {
    let keymap = this.keymap;
    let index  = 0;
    let expandKeymap = function() {
      if(keymap.length !== 1) return;
      if(!keymap[0].isGroup)  return;
      keymap = keymap[0].keymap;
      index  = 0;
    }

    this.keysPressed.forEach((key) => {
      expandKeymap();
      keymap = keymap.filter((kb) => kb.keysequence[index] === key);
      ++index;
    });

    expandKeymap();
    return keymap;
  },

  findData: function(data) {
    let findIn = function(km) {
      for(let i in km) {
        let kb = km[i];
        if(kb.data === data) return kb;
        if(!kb.isGroup) continue;
        let found = findIn(kb.keymap);
        if(found) return found;
      }
    };
    let found = findIn(this.keymap);
    if(found) return found;
    throw `DID NOT HAVE ${data}`
  },

}

module.exports = KeyMapper;
