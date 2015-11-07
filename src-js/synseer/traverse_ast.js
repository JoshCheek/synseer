'use strict';

var TraverseAst = function(ast, cb) {
  this.ast = ast;
  this._cb = cb;
}

TraverseAst.prototype.successor = function() {
  if(this.ast.children.length == 0) return (this._cb||function(){})();
  return this.ast.children.reduceRight(
    function(cb, childAst) {
      return function() { return new TraverseAst(childAst, cb) };
    },
    this._cb
  )()
}

module.exports = TraverseAst;
