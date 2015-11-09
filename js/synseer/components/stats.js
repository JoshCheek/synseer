var React    = require('react');
var ReactDOM = require('react-dom');

var Stats = React.createClass({
  getInitialState: function(){
    return {time: 0, correct: 0, incorrect: 0};
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

ReactDOM.render(
  <Stats />,
  document.getElementById('stats-react')
);
