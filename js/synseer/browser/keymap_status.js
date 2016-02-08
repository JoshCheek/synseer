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
    return this.potentialEntries(keybindings);
  },

  potentialEntries: function(keybindings) {
    // this if statement is fkn terrible >.<
    if(keybindings.name === 'All Keybindings') {
      return `<table class="potential_entries">${this.rowsFor(1, keybindings.children)}</table>`;
    } else {
      return `<table class="potential_entries">${this.keybinding(1, keybindings)}</table>`;
    }
  },

  rowsFor: function(depth, keybindings) {
    let newEntries = "";
    for(let index in (keybindings||[])) {
      newEntries += this.keybinding(depth, keybindings[index]);
    }
    return newEntries;
  },

  keybinding: function(depth, kb) {
    if(depth < 0 || !kb) return "";

    if(!kb.isGroup()) return `
      <tr class="potential_entry">
        <td class="keybinding">${kb.key}</td>
        <td class="syntax_node">${kb.english}</td>
      </tr>
    `;

    if(kb.key === '') {
      return `
      <tr>
        <td class="entry_group group_header" colspan="2">${kb.name}</td>
      </tr>${this.rowsFor(depth-1, kb.children)}`;
    }

    return `
      <tr>
        <td class="keybinding">${kb.key}</td>
        <td class="entry_group">${kb.name}</td>
      </tr>
      ${this.rowsFor(depth-1, kb.children)}
    `;
  },

}

module.exports = KeymapStatus;
