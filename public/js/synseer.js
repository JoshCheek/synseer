(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);throw new Error("Cannot find module '"+o+"'")}var f=n[o]={exports:{}};t[o][0].call(f.exports,function(e){var n=t[o][1][e];return s(n?n:e)},f,f.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
'use strict';

window.Synseer = window.Synseer || {};

Synseer.DefaultKeymap = {
  "M": "send",
  "I": "int",
  "A": "array",
  "B": "begin",
  "F": "if",
  "L": "lvar",
  "Shift-L": "lvasgn",
  "Shift-O": "op_asgn",
  "S": "str",
  "W": "while"
};

},{}],2:[function(require,module,exports){
'use strict';

window.Synseer = window.Synseer || {};

Synseer.Game = function (attrs) {
  var game = this;
  this._traverse = new Synseer.TraverseAst(attrs.ast);
  this._statsView = attrs.statsView;
  this._codeMirror = attrs.codeMirror;
  this._keyMap = attrs.keyMap;
  this._onFinished = attrs.onFinished;
  this._isFinished = false;
};

Synseer.Game.prototype.init = function () {
  this._initCodeMirror();
  this._statsView.init();
};

Synseer.Game.prototype.start = function (getTime, setInterval) {
  var ast = this._traverse.ast;
  this._currentElement = this._codeMirror.markText({ line: ast.begin_line, ch: ast.begin_col }, { line: ast.end_line, ch: ast.end_col }, { className: "currentElement" });
  var game = this;
  var startTime = getTime();
  this._timerIntervalId = setInterval(function () {
    var milliseconds = getTime() - startTime;
    var seconds = parseInt(milliseconds / 1000);
    game._statsView.updateDuration(seconds);
  }, 1000);
};

Synseer.Game.prototype.finish = function () {
  this._isFinished = true;
  window.clearInterval(this._timerIntervalId); // TOOD modifies global state
  this._onFinished();
  jQuery.post(window.location.pathname, { "game": this._statsView.data() }); // TODO more global deps
};

Synseer.Game.prototype.isFinished = function () {
  return this._isFinished;
};

Synseer.Game.prototype.pressKey = function (key) {
  if (this.isFinished()) {
    if (key === 'Enter') window.location = window.location.origin;
    return;
  }
  var selectedType = this._keyMap[key];
  var type = this._traverse.ast.type;
  if (selectedType == type) {
    this._statsView.incrementCorrect();
    this._currentElement.clear();
    this._traverse = this._traverse.successor();
    if (this._traverse) {
      var ast = this._traverse.ast;
      this._currentElement = this._codeMirror.markText({ line: ast.begin_line, ch: ast.begin_col }, { line: ast.end_line, ch: ast.end_col }, { className: "currentElement" });
    } else {
      this.finish();
    }
  } else {
    this._statsView.incrementIncorrect();
  }
};

Synseer.Game.prototype._initCodeMirror = function () {
  // seriously no clue why the interface works this way, it makes no sense to me, and took me forever to figure out >.<
  var game = this;
  var cmKeyMap = { call: function (key) {
      return function () {
        game.pressKey(key);return "handled";
      };
    } }; // can also return "multi"
  var codeMirror = this._codeMirror;
  codeMirror.setOption("readOnly", true);
  codeMirror.setOption("cursorBlinkRate", -1); // hides the cursor
  codeMirror.setOption("disableInput", true);
  codeMirror.setOption("showCursorWhenSelecting", false);
  codeMirror.setOption("keyMap", cmKeyMap);
};

},{}],3:[function(require,module,exports){
'use strict';

window.Synseer = window.Synseer || {};

Synseer.StatsView = function (domElement) {
  this.domElement = domElement;
  this.domCorrect = domElement.getElementsByClassName('correct')[0];
  this.domIncorrect = domElement.getElementsByClassName('incorrect')[0];
  this.domTime = domElement.getElementsByClassName('time')[0];
};

Synseer.StatsView.prototype.init = function () {
  this.updateDuration(0);
  this._numCorrect = -1;
  this.incrementCorrect();
  this._numIncorrect = -1;
  this.incrementIncorrect();
};

Synseer.StatsView.prototype.data = function () {
  return {
    duration: this._duration,
    correct: this._numCorrect,
    incorrect: this._numIncorrect
  };
};

Synseer.StatsView.prototype.updateDuration = function (secondsElapsed) {
  this._duration = secondsElapsed;
  this.domTime.textContent = this.formatDuration(secondsElapsed);
};

Synseer.StatsView.prototype.formatDuration = function (secondsElapsed) {
  var minutes = parseInt(secondsElapsed / 60);
  var seconds = secondsElapsed % 60;
  return "" + minutes + ":" + (seconds > 9 ? parseInt(seconds / 10) : "0") + seconds % 10; // JS apparently has no sprintf or rjust
};

Synseer.StatsView.prototype.incrementCorrect = function () {
  this._numCorrect++;
  this.domCorrect.textContent = this._numCorrect;
};

Synseer.StatsView.prototype.incrementIncorrect = function () {
  this._numIncorrect++;
  this.domIncorrect.textContent = this._numIncorrect;
};

},{}],4:[function(require,module,exports){
'use strict';

window.Synseer = window.Synseer || {};

Synseer.TraverseAst = function (ast, cb) {
  this.ast = ast;
  this._cb = cb;
};

Synseer.TraverseAst.prototype.successor = function () {
  if (this.ast.children.length == 0) return (this._cb || function () {})();
  return this.ast.children.reduceRight(function (cb, childAst) {
    return function () {
      return new Synseer.TraverseAst(childAst, cb);
    };
  }, this._cb)();
};

},{}]},{},[1,2,3,4])