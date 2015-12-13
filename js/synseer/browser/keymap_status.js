function KeymapStatus(domElement) {
  this.domElement = domElement;
}

KeymapStatus.prototype = {
  create: function() {
    // <div class="keymap_status">
    //   <div class="user_entry"></div>
    //   <table class="potential_entries">
    //   </table>
    // </div>
    this.domElement.classList.add("keymap_status");

    this.user_entry = document.createElement("div");
    this.user_entry.classList.add("user_entry");
    this.domElement.appendChild(this.user_entry);

    this.potential_entries = document.createElement("table");
    this.potential_entries.classList.add("potential_entries");
    this.domElement.appendChild(this.potential_entries);
  },

  update: function(input, possibilities) {
    let newEntries = "";
    for(let key in possibilities) {
      newEntries += '<tr class="potential_entry">' +
                      '<td class="keybinding"> '+ key + '</td>' +
                      '<td class="syntax_node"> '+ possibilities[key] + '</td>' +
                    '</tr>'
    }
    // FIXME: when I get the energy, figure out how to do this from the domElement,
    // and ideally without the jquery
    $('.potential_entries').html(newEntries);
    $('.user_entry').text(input);
  }
}

module.exports = KeymapStatus;
