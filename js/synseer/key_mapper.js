'use strict';

var KeyMapper = function(map) {
  this.map = map;
  this.keysPressed = [];
  KeyMapper.validateMap(map);
}

KeyMapper.KeyConflictError = function(conflictingKeys) {
  this.conflictingKeys = conflictingKeys;
  this.name            = 'KeyConflictError';
  var conflictStr      = conflictingKeys
                           .map(([key, child]) => `[${key}, ${child}]`)
                           .join(", ")
  this.message         = `Conflicts: ${conflictStr}`;
}
KeyMapper.KeyConflictError.prototype = new Error();
KeyMapper.KeyConflictError.prototype.constructor = KeyMapper.KeyConflictError;


KeyMapper.fromCodemirror = function(key) {
  var match = (/^SHIFT-(.+)/).exec(key);
  if(match) return match[1].toUpperCase();
  return key.toLowerCase();
}

// http://www.sitepoint.com/exceptional-exception-handling-in-javascript/
KeyMapper.validateMap = function(map) {
  var conflictingKeys = [];
  for(var keybinding in map) {
    for(var maybeChild in map) {
      // if length is less, then it can't be a child
      // if length is the same, then it either is keybinding, or takes a different path
      if(maybeChild.length <= keybinding.length) continue;
      var otherSubstr = maybeChild.substr(0, keybinding.length)
      if(otherSubstr === keybinding)
        conflictingKeys.push([keybinding, maybeChild]);
    }
  }
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
    return fragment == string.substring(0,fragment.length);
  },

  possibilities: function() {
    var fragment = this.keysPressed.join("");
    var matchedWords = [];
    for (var keybinding in this.map) {
      if (this.startsWith(keybinding, fragment)) {
        matchedWords.push(this.map[keybinding]);
      }
    }
    return matchedWords;
  }
}

module.exports = KeyMapper;
