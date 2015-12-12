'use strict';

var KeyMapper = function(map) {
  this.map = map;
  this.keysPressed = [];
}

KeyMapper.fromCodemirror = function(key) {
  var match = (/^SHIFT-(.+)/).exec(key);
  if(match) return match[1].toUpperCase();
  return key.toLowerCase();
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
