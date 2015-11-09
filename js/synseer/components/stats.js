var React = require('react');
var $     = require('jquery');
var Stats = React.createClass({
  getInitialState: function(){
    return {duration: 0, correct: 0, incorrect: 0};
  },
  componentDidMount: function() {
    var $window = $(window);

    $window.on('synseerGuess', (event, data) => {
      if(data.result === 'correct') {
        this.setState({correct: this.state.correct+1});
      } else if (data.result === 'incorrect') {
        this.setState({incorrect: this.state.incorrect+1});
      } else {
        console.log(data);
        throw "Got an unexpected synseerGuess result, check the log";
      }
    });

    $window.on('synseerDuration', (event, data) => {
      this.setState({duration: data.seconds});
    });
  },

  formattedDuration: function() {
    var secondsElapsed = this.state.duration;
    var minutes        = parseInt(secondsElapsed / 60);
    var seconds        = secondsElapsed % 60;
    return "" + minutes + ":" + (seconds > 9 ? parseInt(seconds / 10) : "0") + (seconds % 10); // JS apparently has no sprintf or rjust
  },

  render: function(){
    return(
      <div>
        <div className="time">{this.formattedDuration()}</div>
        <div className="correct">{this.state.correct}</div>
        <div className="incorrect">{this.state.incorrect}</div>
      </div>
    );
  }
});

module.exports = Stats;
