function KeymapStatus(domElement) {
  this.domElement = domElement;
  domElement.classList.add("keymap_status");
}

function log(obj) {
  console.log(JSON.stringify(obj));
}

KeymapStatus.prototype = {
  update: function(input, keybindings) {
    this.domElement.innerHTML = this.htmlFor(input, keybindings);
  },

  htmlFor: function(input, keybindings) {
    return this.userEntry(input) + this.potentialEntries(keybindings);
  },

  userEntry: function(input) {
    return `<div class="user_entry">${input}</div>`;
  },

  potentialEntries: function(keybindings) {
    return `<table class="potential_entries">${this.rowsFor(keybindings)}</table>`;
  },

  rowsFor: function(keybindings) {
    let newEntries = "";
    for(let index in keybindings) {
      newEntries += this.keybinding(keybindings[index]);
    }
    return newEntries;
  },

  keybinding: function(kb) {
    if(kb.isGroup()) return `
      <tr>
        <td colspan="2" class="entry_group">${kb.english}</td>
      </tr>
      <tr class="potential_entry">
        <td colspan="2">${this.rowsFor(kb.keymap)}</td>
      </tr>`;
    else return `
      <tr class="potential_entry">
        <td class="keybinding">${kb.keysequence}</td>
        <td class="syntax_node">${kb.english}</td>
      </tr>`;
  },

}

module.exports = KeymapStatus;
