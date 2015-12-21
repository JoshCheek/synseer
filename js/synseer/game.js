'use strict';
var KeyMapper   = require('./key_mapper');
var TraverseAst = require("./traverse_ast");

var Game = function(attrs) {
  var game              = this;
  this._setMessage      = attrs.setMessage;
  this._ast             = attrs.ast;
  this._statsView       = attrs.statsView;
  this._codeMirror      = attrs.codeMirror;
  this._keyMap          = attrs.keyMap;
  this._onFinished      = attrs.onFinished;
  this._isFinished      = false;
  this._stats           = {numCorrect: 0, numIncorrect: 0, duration: 0};
  this._onPossibilities = attrs.onPossibilities;
  this._maxStepsTraversed = 0;
}

Game.prototype.init = function() {
  this._initCodeMirror();
  this._statsView.setNumCorrect(0);
  this._statsView.setNumIncorrect(0);
  this._statsView.setDuration(0);
  this._onPossibilities(this._keyMap.input(), this._keyMap.possibilities(true));
}

Game.prototype.start = function(getTime, setInterval) {
  this.resetTraversal();
  var game               = this;
  var startTime          = getTime();
  this._timerIntervalId  = setInterval(function() {
    var milliseconds     = getTime() - startTime;
    var seconds          = parseInt(milliseconds / 1000);
    game._stats.duration = seconds;
    game._statsView.setDuration(seconds);
  }, 1000);
}

Game.prototype.finish = function() {
  let clone = (obj) => JSON.parse(JSON.stringify(obj))
  this._isFinished = true;
  window.clearInterval(this._timerIntervalId); // TOOD modifies global state
  this.finishTraversal();
  this._onFinished(clone(this._stats));
}

Game.prototype.isFinished = function() {
  return this._isFinished;
}

Game.prototype.pressKey = function(key) {
  if(this.isFinished()) return;
  var possibilities = this._keyMap.keyPressed(key);
  var selected      = possibilities[0];

  if(1 < possibilities.length) {
    this._onPossibilities(this._keyMap.input(), this._keyMap.possibilities(true));
    return;
  }

  let accepted = this._keyMap.accept()
  // stupid: we have to do this first, b/c it changes the input
  // command/query violation, I guess -.^
  this._onPossibilities(this._keyMap.input(), accepted);
  var targetAst = this._traverse.ast.type;

  if(selected.data == targetAst) {
    if(this.isFirstTraversal())
      this._statsView.setNumCorrect(++this._stats.numCorrect);
    this._traverse = this._traverse.successor();
    this._setMessage(`Correct: ${selected.keysequence}, ${selected.english}`, 'positive');
    if(this._traverse) this.advanceTraversal();
    else               this.finish();
  } else {
    this._statsView.setNumIncorrect(++this._stats.numIncorrect);
    var expected = this._keyMap.findData(targetAst);
    this._setMessage(`Incorrect: ${expected.keysequence}, ${expected.english}`, 'negative');
  }
}


// ----- TODO: Can we push this down into traverse_ast with some callbacks? -----
Game.prototype._clearElement = function() {
  if(this._currentElement) this._currentElement.clear();
}
Game.prototype.finishTraversal = function() {
  this._clearElement();
}
Game.prototype.isFirstTraversal = function() {
  return this._stepsTraversed == this._maxStepsTraversed;
}
Game.prototype.advanceTraversal = function() {
  this._clearElement();
  this._stepsTraversed++;
  if(this._maxStepsTraversed < this._stepsTraversed)
    this._maxStepsTraversed = this._stepsTraversed;
  var ast = this._traverse.ast;
  this._currentElement = this._codeMirror.markText(
    {line: ast.begin_line, ch: ast.begin_col},
    {line: ast.end_line,   ch: ast.end_col},
    {className: "currentElement"}
  );
}
Game.prototype.resetTraversal = function() {
  this._clearElement();
  this._stepsTraversed = 0;
  this._traverse = new TraverseAst(this._ast);
  this._traverse = this._traverse.successor(); // skip toplevel "program" node
  let ast = this._traverse.ast;

  this._currentElement = this._codeMirror.markText(
    {line: ast.begin_line, ch: ast.begin_col},
    {line: ast.end_line,   ch: ast.end_col},
    {className: "currentElement"}
  );
}

Game.prototype._initCodeMirror = function() {
  var codeMirror = this._codeMirror;
  codeMirror.setOption("readOnly",                true);
  codeMirror.setOption("cursorBlinkRate",         -1); // hides the cursor
  codeMirror.setOption("disableInput",            true);
  codeMirror.setOption("showCursorWhenSelecting", false);

  codeMirror.setOption("keyMap", {
    call: function(key) {
      return function() { }
    }
  });
}

module.exports = Game;
