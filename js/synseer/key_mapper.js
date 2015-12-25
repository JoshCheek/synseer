'use strict';

function Mapper(keybindings) {
  this._keybindings = keybindings;
  this._keysPressed = [];
}

Mapper.normalize = function(key) {
  key = key.toLowerCase();
  if(key === 'esc') key = 'escape';

  let match = (/^shift-(.+)/).exec(key);
  if(match) key = match[1].toUpperCase();

  return key;
}

Mapper.prototype = {
  findData: function(data) {
    return this._keybindings.findData(data);
  },

  keyPressed: function(key) {
    key = Mapper.normalize(key);
    if(key == 'backspace')
      this._keysPressed.pop();
    else if(key == 'escape')
      while(0 < this._keysPressed.length)
        this._keysPressed.pop();
    else if((/^[a-zA-Z]$/).exec(key))
      this._keysPressed.push(key);

    return null;
  },

  potentials: function() {
    return this._keybindings.potentialsFor(this._keysPressed);
  },

  accept: function() {
    while(0 < this._keysPressed.length)
      this._keysPressed.pop();
    return null;
  },
}

module.exports = Mapper;
