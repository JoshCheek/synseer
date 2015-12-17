'use strict';

let KeyMapper = function(keymap) {
  this.keymap = keymap;
  this.keysPressed = [];
  KeyMapper.validateMap(keymap);
}

KeyMapper.KeyConflictError = function(conflictingKeys) {
  this.conflictingKeys = conflictingKeys;
  this.name            = 'KeyConflictError';
  let conflictStr      = conflictingKeys.map(([key, child]) => `[${key}, ${child}]`).join(", ")
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
  const conflictingKeys = [];
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
    let matchedWords = [];
    for (let i in this.keymap) {
      if (this.startsWith(this.keymap[i].keysequence, this.input()))
        matchedWords.push(this.keymap[i]);
    }
    return matchedWords;
  },

  findData: function(data) {
    for(let i in this.keymap) {
      if(this.keymap[i].data === data) return this.keymap[i];
    }
    // const found = this.keymap.find(kb => kb.hasData(data));
    // if(found) return found;
    throw `DID NOT HAVE ${data}`
  },

}

module.exports = KeyMapper;
