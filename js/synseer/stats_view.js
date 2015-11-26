'use strict';

var StatsView = function(domElement) {
  this.domElement        = domElement;
  this.domCorrect        = domElement.querySelector('.correct');
  this.domIncorrect      = domElement.querySelector('.incorrect');
  this.domTime           = domElement.querySelector('.time');
  this.domGamesCompleted = domElement.querySelector('.games_completed');
}

StatsView.prototype = {
  setGamesCompleted: function(n) {
    this.domGamesCompleted.textContent = n;
  },

  setNumCorrect: function(n) {
    this.domCorrect.textContent = n;
  },

  setNumIncorrect: function(n) {
    this.domIncorrect.textContent = n;
  },

  setDuration: function(secondsElapsed) {
    this.domTime.textContent = this.formatDuration(secondsElapsed);
  },

  formatDuration: function(secondsElapsed) {
    // JS apparently has no sprintf or rjust
    var minutes = parseInt(secondsElapsed / 60);
    var seconds = secondsElapsed % 60;
    return "" + minutes + ":" + (seconds > 9 ? parseInt(seconds / 10) : "0") + (seconds % 10);
  }
}

module.exports = StatsView;
