'use strict';
window.Synseer = window.Synseer||{};

Synseer.TraverseAst = function(ast, cb) {
  this.ast = ast;
  this._cb = cb;
}

Synseer.TraverseAst.prototype.successor = function() {
  if(this.ast.children.length == 0) return (this._cb||function(){})();
  return this.ast.children.reduceRight(
    function(cb, childAst) {
      return function() { return new Synseer.TraverseAst(childAst, cb) };
    },
    this._cb
  )()
}
