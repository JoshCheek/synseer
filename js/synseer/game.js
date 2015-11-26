'use strict';
var TraverseAst = require("./traverse_ast");
var Game = function(attrs) {
  var game         = this;
  this._traverse   = new TraverseAst(attrs.ast)
  this._statsView  = attrs.statsView;
  this._codeMirror = attrs.codeMirror;
  this._keyMap     = attrs.keyMap;
  this._onFinished = attrs.onFinished;
  this._isFinished = false;
  this._stats      = {numCorrect: 0, numIncorrect: 0, duration: 0};
}

Game.prototype.init = function() {
  this._initCodeMirror();
  this._statsView.setNumCorrect(0);
  this._statsView.setNumIncorrect(0);
  this._statsView.setDuration(0);
}

Game.prototype.start = function(getTime, setInterval) {
  var ast = this._traverse.ast;
  this._currentElement = this._codeMirror.markText(
    {line: ast.begin_line, ch: ast.begin_col},
    {line: ast.end_line,   ch: ast.end_col},
    {className: "currentElement"}
  );
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
  this._isFinished = true;
  window.clearInterval(this._timerIntervalId); // TOOD modifies global state
  this._onFinished();
}

Game.prototype.isFinished = function() {
  return this._isFinished;
}

Game.prototype.pressKey = function(key) {
  if(this.isFinished()) {
    if(key === 'Enter')
      window.location = window.location.origin;
    return;
  }
  var selectedType = this._keyMap[key];
  var type         = this._traverse.ast.type
  console.log({expected: type, actual: selectedType, key: key, keymap: this._keyMap});
  if(selectedType == type) {
    this._statsView.setNumCorrect(
      ++this._stats.numCorrect
    );
    this._currentElement.clear();
    this._traverse = this._traverse.successor();
    if(this._traverse) {
      var ast = this._traverse.ast;
      this._currentElement = this._codeMirror.markText(
        {line: ast.begin_line, ch: ast.begin_col},
        {line: ast.end_line,   ch: ast.end_col},
        {className: "currentElement"}
      );
    } else {
      this.finish();
    }
  } else {
    this._statsView.setNumIncorrect(
      ++this._stats.numIncorrect
    );
  }
}

Game.prototype._initCodeMirror = function() {
  // seriously no clue why the interface works this way, it makes no sense to me, and took me forever to figure out >.<
  var game       = this;
  var cmKeyMap   = {call: function(key) { return function() { game.pressKey(key); return "handled"; }}}; // can also return "multi"
  var codeMirror = this._codeMirror;
  codeMirror.setOption("readOnly",                true);
  codeMirror.setOption("cursorBlinkRate",         -1); // hides the cursor
  codeMirror.setOption("disableInput",            true);
  codeMirror.setOption("showCursorWhenSelecting", false);
  codeMirror.setOption("keyMap",                  cmKeyMap);
}

module.exports = Game;
