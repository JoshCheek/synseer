require 'parser/ruby22'

module Synseer
  module Parse
    extend self
    def ast_for(ruby_code)
      to_js_ast = lambda do |ast|
        return nil unless ast.kind_of?(AST::Node) && ast.loc.expression
        { type:       ast.type,
          begin_line: ast.loc.expression.begin.line-1,
          begin_col:  ast.loc.expression.begin.column,
          end_line:   ast.loc.expression.end.line-1,
          end_col:    ast.loc.expression.end.column,
          children:   ast.children.map(&to_js_ast).compact,
        }
      end
      to_js_ast.call ::Parser::Ruby22.parse ruby_code
    end
  end
end
