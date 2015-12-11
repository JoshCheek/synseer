'use strict';

var Mapper = function(map) {
  this.map = map;
  this.keysPressed = [];
}

Mapper.fromCodemirror = function(key) {
  var match = (/^SHIFT-(.+)/).exec(key);
  if(match) return match[1].toUpperCase();
  return key.toLowerCase();
}

Mapper.prototype = {
  accept: function() {
    this.keysPressed = [];
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
    var fragment = this.keysPressed.join("");
    var matchedWords = [];

    for (var keybinding in this.map) {
      if (this.startsWith(keybinding, fragment)) {
        matchedWords.push(this.map[keybinding]);
      }
    }
    return matchedWords;
  },

  startsWith: function(string, fragment) {
    return fragment == string.substring(0,fragment.length);
  }
}

module.exports = Mapper;
