var Mapper = function(map) {
  this.map = map;
  this.keysPressed = [];
  this.matchedWords = [];
}

Mapper.prototype.keyPressed = function(input) {
  this.keysPressed.push(input);
  var inputWord = this.keysPressed.join("");

  for (var key in this.map) {
    if (key.substring(0,inputWord.length) == inputWord) {
      // add word to the collection of matched words
      this.matchedWords.push(this.map[key]);
    }
  }
  return this.matchedWords;
}

module.exports = Mapper;