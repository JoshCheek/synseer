require 'parser/ruby22'

module Synseer
  module Parse
    EXCLUDED_TYPES = [:args, :begin, :pair, :when, :resbody].freeze

    TYPE_ALIAS = Hash.new { |h, k| k }
    TYPE_ALIAS[:until_post] = :until

    extend self
    def ast_for(ruby_code)
      child_map = to_hash_ast = wrap_program = nil

      to_hash_ast = lambda do |ast|
        { type:       TYPE_ALIAS[ast.type],
          begin_line: ast.loc.expression.begin.line-1,
          begin_col:  ast.loc.expression.begin.column,
          end_line:   ast.loc.expression.end.line-1,
          end_col:    ast.loc.expression.end.column,
          children:   ast.children.map(&child_map).compact.flatten,
        }
      end

      child_map = lambda do |ast; hash_ast|
        if !ast.kind_of?(AST::Node) || !ast.loc.expression
          nil
        elsif EXCLUDED_TYPES.include?(ast.type)
          to_hash_ast[ast][:children]
        else
          to_hash_ast[ast]
        end
      end

      wrap_program = lambda do |hash_ast|
        children            = [hash_ast]
        children            = hash_ast[:children] if hash_ast[:type] == :begin
        hash_ast            = hash_ast.dup
        hash_ast[:type]     = :program
        hash_ast[:children] = children
        hash_ast
      end

      wrap_program.call to_hash_ast.call ::Parser::Ruby22.parse ruby_code
    end

    def nodes_in(*codes)
      codes.map { |code| ast_for code }
           .inject([]) { |types, ast| node_types ast, types }
           .uniq
           .sort
    end

    private

    def node_types(ast, list)
      type = ast.fetch(:type)
      list << type unless type == :program
      ast.fetch(:children).each { |child| node_types child, list }
      list
    end
  end
end
