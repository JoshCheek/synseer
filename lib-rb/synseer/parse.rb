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

    def nodes_in(*codes)
      codes.map { |code| ast_for code }
           .inject([]) { |types, ast| node_types ast, types }
           .uniq
           .sort
    end

    private

    def node_types(ast, list)
      list << ast.fetch(:type)
      ast.fetch(:children).each { |child| node_types child, list }
      list
    end
  end
end
