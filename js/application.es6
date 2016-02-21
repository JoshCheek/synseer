// https://github.com/MichaelBaker/science/blob/027df4d38975874c13c26dfa297d3dee80a9829d/client/src/components/science.es6
import React    from 'react'
import ReactDOM from 'react-dom'

console.log("JS IS LOADED");
class Game extends React.Component {
  // React.PropTypes.object.isRequired,
  // React.PropTypes.array.isRequired,
  static PropTypes = {};

  render() {
    return (
      <div>
        <h1>Board</h1>
      </div>
    )
  }
}


let render = () => {
  let props = {};
  ReactDOM.render(
    React.createElement(Game, props),
    document.getElementById('content')
  );
};

render();
    /* <div class="icing"> */
    /*   <a class="app_name" href="/">Synseer</a> */
    /*   <div class="total_score stats"> */
    /*     <span class="stat"> */
    /*       <span class="games_completed"></span> */
    /*       Completed */
    /*     </span> */

    /*     <span class="stat"> */
    /*       <span class="correct"></span> */
    /*       Correct */
    /*     </span> */

    /*     <span class="stat"> */
    /*       <span class="incorrect"></span> */
    /*       Incorrect */
    /*     </span> */

    /*     <span class="stat"> */
    /*       <span class="time"></span> */
    /*       Total Time */
    /*     </span> */
    /*   </div> */
    /* </div> */
    /* <div class="cake game-board"> */
    /*   <div class="layer"> */

    /*     <div class="postgame_info_container"> */
    /*       <div class="postgame_info"> */
    /*         <div class="summary"></div> */
    /*         <div class="options">"Enter" goes to the index, "r" replays this game.</div> */
    /*       </div> */
    /*     </div> */

    /*     <div class="side"></div> */
    /*     <div class="col"> */
    /*       <div class="infoBox"> */
    /*         Type the characters you think match the description */
    /*         of the highlighted poriton. */
    /*       </div> */
    /*       <textarea class="cm"><%= @game.fetch(:body) %></textarea> */
    /*     </div> */
    /*   </div> */
    /* </div> */
