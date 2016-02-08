'use strict';

function Mapper(keybindings) {
  this._keybindings = keybindings;
  this._keysPressed = [];
}

Mapper.normalize = function(key) {
  key = key.toLowerCase();
  if(key === 'esc') key = 'escape';

  let match = (/^shift-(.+)/).exec(key);
  if(match) {
    if     (match[1]==="`") key = "~";
    else if(match[1]==="1") key = "!";
    else if(match[1]==="2") key = "@";
    else if(match[1]==="3") key = "#";
    else if(match[1]==="4") key = "$";
    else if(match[1]==="5") key = "%";
    else if(match[1]==="6") key = "^";
    else if(match[1]==="7") key = "&";
    else if(match[1]==="8") key = "*";
    else if(match[1]==="9") key = "(";
    else if(match[1]==="0") key = ")";
    else if(match[1]==="-") key = "_";
    else if(match[1]==="=") key = "+";
    else if(match[1]==="[") key = "{";
    else if(match[1]==="]") key = "}";
    else if(match[1]==="\\") key = "|";
    else if(match[1]===";") key = ":";
    else if(match[1]==="'") key = "\"";
    else if(match[1]===",") key = "<";
    else if(match[1]===".") key = ">";
    else if(match[1]==="/") key = "?";
    else                    key = match[1].toUpperCase();
  }

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
    else if((/^[-.~`|\\!@#$%^&*()=a-zA-Z0-9]$/).exec(key))
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
