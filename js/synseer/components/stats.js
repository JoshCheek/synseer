var React = require('react');
var $     = require('jquery');
var Stats = React.createClass({
  getInitialState: function(){
    return {time: 0, correct: 0, incorrect: 0};
  },
  componentDidMount: function() {
    $(window).on('synseerGuess', (event, data) => {
      if(data.result === 'correct') {
        this.setState({correct: this.state.correct+1});
      } else if (data.result === 'incorrect') {
        this.setState({incorrect: this.state.incorrect+1});
      } else {
        console.log(data);
        throw "Got an unexpected synseerGuess result, check the log";
      }
    });
    console.log("MOUNTED");
  },
  render: function(){
    return(
      <div>
        <div className="time">{this.state.time}</div>
        <div className="correct">{this.state.correct}</div>
        <div className="incorrect">{this.state.incorrect}</div>
      </div>
    );
  }
});

module.exports = Stats;
