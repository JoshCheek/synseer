function KeymapStatus(domElement) {
  this.domElement = domElement;
  domElement.classList.add("keymap_status");
}

KeymapStatus.prototype = {
  update: function(input, possibilities) {
    let newEntries = "";
    for(let key in possibilities) {
      newEntries +=
        `<tr class="potential_entry">
          <td class="keybinding">${key}</td>
          <td class="syntax_node">${possibilities[key]}</td>
        </tr>`
    }
    this.domElement.innerHTML = `<div class="user_entry">${input}</div>`+
                                `<table class="potential_entries">${newEntries}</table>`
  }
}

module.exports = KeymapStatus;
