var Mapper = function(map) {
  this.map = map;
  this.keysPressed = [];
}

Mapper.prototype = {
  keyPressed: function(input) {
    if(input=="delete") {
      this.keysPressed.pop();
    } else if(input == "escape") {
      this.keysPressed = [];
    } else {
      // (/a.b/).exec("axb")
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
