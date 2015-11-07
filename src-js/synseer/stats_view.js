'use strict';

var StatsView = function(domElement) {
  this.domElement   = domElement;
  this.domCorrect   = domElement.getElementsByClassName('correct')[0];
  this.domIncorrect = domElement.getElementsByClassName('incorrect')[0];
  this.domTime      = domElement.getElementsByClassName('time')[0];
}

StatsView.prototype.init = function() {
  this.updateDuration(0);
  this._numCorrect = -1;
  this.incrementCorrect();
  this._numIncorrect = -1;
  this.incrementIncorrect();
}

StatsView.prototype.data = function() {
  return {
    duration:  this._duration,
    correct:   this._numCorrect,
    incorrect: this._numIncorrect,
  }
}

StatsView.prototype.updateDuration = function(secondsElapsed) {
  this._duration = secondsElapsed;
  this.domTime.textContent = this.formatDuration(secondsElapsed);
}

StatsView.prototype.formatDuration = function(secondsElapsed) {
  var minutes = parseInt(secondsElapsed / 60);
  var seconds = secondsElapsed % 60;
  return "" + minutes + ":" + (seconds > 9 ? parseInt(seconds / 10) : "0") + (seconds % 10); // JS apparently has no sprintf or rjust
}

StatsView.prototype.incrementCorrect = function() {
  this._numCorrect++;
  this.domCorrect.textContent = this._numCorrect;
}

StatsView.prototype.incrementIncorrect = function() {
  this._numIncorrect++;
  this.domIncorrect.textContent = this._numIncorrect;
}

module.exports = StatsView;
