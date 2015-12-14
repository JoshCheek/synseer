'use strict';

var StatsView = function(domElement) {
  this.domElement        = domElement;
  this.domStatus         = domElement.querySelector('.status');
  this.domCorrect        = domElement.querySelector('.correct');
  this.domIncorrect      = domElement.querySelector('.incorrect');
  this.domTime           = domElement.querySelector('.time');
  this.domGamesCompleted = domElement.querySelector('.games_completed');
}

StatsView.prototype = {
  setGamesCompleted: function(n) {
    this.domGamesCompleted.textContent = n;
  },

  setStatus: function(status) {
    this.domElement.classList.add(status.toLowerCase());
    this.domStatus.textContent = status;
  },

  setNumCorrect: function(n) {
    this.domCorrect.textContent = n;
  },

  setNumIncorrect: function(n) {
    this.domIncorrect.textContent = n;
  },

  setDuration: function(secondsElapsed) {
    if(typeof secondsElapsed === "number")
      secondsElapsed = this.formatDuration(secondsElapsed);
    this.domTime.textContent = secondsElapsed
  },

  formatDuration: function(secondsElapsed) {
    // JS apparently has no sprintf or rjust
    var minutes = parseInt(secondsElapsed / 60);
    var seconds = secondsElapsed % 60;
    return "" + minutes + ":" + (seconds > 9 ? parseInt(seconds / 10) : "0") + (seconds % 10);
  }
}

module.exports = StatsView;
