function KeymapStatus(domElement) {
  this.domElement = domElement;
  domElement.classList.add("keymap_status");
}

KeymapStatus.prototype = {
  update: function(input, keybindings) {
    let newEntries = "";
    for(let index in keybindings) {
      let kb = keybindings[index];
      newEntries += `<tr class="potential_entry">
                       <td class="keybinding">${kb.keysequence}</td>
                       <td class="syntax_node">${kb.english}</td>
                     </tr>`
    }
    this.domElement.innerHTML = `<div class="user_entry">${input}</div>`+
                                `<table class="potential_entries">${newEntries}</table>`
  }
}

module.exports = KeymapStatus;
