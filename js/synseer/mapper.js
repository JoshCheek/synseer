var Mapper = function(map) {
  this.map = map;
  this.keysPressed = [];
}

Mapper.prototype.keyPressed = function(input) {
  this.keysPressed.push(input);
  var inputWord = this.keysPressed.join("");
  var matchedWords = [];

  for (var key in this.map) {
    if (key.substring(0,inputWord.length) == inputWord) {
      // add word to the collection of matched words
      matchedWords.push(this.map[key]);
    }
  }
  return matchedWords;
}

module.exports = Mapper;
