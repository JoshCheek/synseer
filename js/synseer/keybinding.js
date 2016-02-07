let Keybinding = function(attrs) {
  this.data    = attrs.data;
  this.key     = attrs.key;
  this.english = attrs.english;
}
Keybinding.for = function(data, key, english) {
  return new Keybinding({data: data, key: key, english: english});
}
Keybinding.prototype = {
  isGroup: function() { return false },
  findData: function(data) {
    return (data === this.data) ? this : null;
  },
  potentialsFor: function(keysPressed) {
    if(this.key.length < keysPressed.length) return null;
    for(let i=0; i<keysPressed.length; ++i)
      if(keysPressed[i] !== this.key[i]) return null;
    return this;
  }
}


Keybinding.Group = function(attrs) {
  this.name     = attrs.name;
  this.key      = attrs.key;
  this.children = attrs.children;
}

Keybinding.Group.for = function(name, key, children) {
  return new Keybinding.Group({name: name, key: key, children: children});
}

Keybinding.Group.prototype = {
  findData: function(data) {
    let found = null;
    for(let index in this.children) {
      found = this.children[index].findData(data);
      if(found) break;
    };
    return found;
  },
  isGroup: function() { return true; },
  isEmpty: function() { return this.children.length == 0; },
  potentialsFor: function(keysPressed) {
    let pressed = [].concat(keysPressed);

    let noMatch = new Keybinding.Group({name: this.name, key: this.key, children: []});
    for(let i=0; i<pressed.length && i < this.key.length; ++i)
      if(pressed[i] !== this.key[i]) return noMatch;

    let newKeysPressed = [];
    for(let i=this.key.length; i<keysPressed.length; ++i)
      newKeysPressed.push(keysPressed[i]);

    let newChildren = this.children.map(child => child.potentialsFor(newKeysPressed));
    newChildren = newChildren.filter((child) => {
      if(!child) return false;
      if(child.isGroup() && child.isEmpty()) return false;
      return true;
    });

    if(newChildren.length === 1 && newChildren[0].isGroup())
      return newChildren[0];
    else
      return new Keybinding.Group({name: this.name, key: '', children: newChildren});
  },
}

module.exports = Keybinding;
