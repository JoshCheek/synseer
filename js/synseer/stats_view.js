'use strict';

var StatsView = function(domElement) {
  this.domElement   = domElement;
  this.domCorrect   = domElement.getElementsByClassName('correct')[0];
  this.domIncorrect = domElement.getElementsByClassName('incorrect')[0];
  this.domTime      = domElement.getElementsByClassName('time')[0];
}

StatsView.prototype = {
  function init() {
    this.updateDuration(0);
    this._numCorrect = -1;
    this.incrementCorrect();
    this._numIncorrect = -1;
    this.incrementIncorrect();
  },

  function data() {
    return {
      duration:  this._duration,
      correct:   this._numCorrect,
      incorrect: this._numIncorrect,
    }
  },

  function updateDuration(secondsElapsed) {
    this._duration = secondsElapsed;
    this.domTime.textContent = this.formatDuration(secondsElapsed);
  },

  function formatDuration(secondsElapsed) {
    var minutes = parseInt(secondsElapsed / 60);
    var seconds = secondsElapsed % 60;
    return "" + minutes + ":" + (seconds > 9 ? parseInt(seconds / 10) : "0") + (seconds % 10); // JS apparently has no sprintf or rjust
  },

  function incrementCorrect() {
    this._numCorrect++;
    this.domCorrect.textContent = this._numCorrect;
  },

  function incrementIncorrect() {
    this._numIncorrect++;
    this.domIncorrect.textContent = this._numIncorrect;
  }
}

module.exports = StatsView;
