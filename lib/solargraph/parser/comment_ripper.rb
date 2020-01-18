require 'ripper'

module Solargraph
  module Parser
    class CommentRipper < Ripper::SexpBuilder
      def initialize src, filename = '(ripper)', lineno = 0
        super
        @buffer = src
        @buffer_lines = @buffer.lines
      end

      def on_comment *args
        result = super
        if @buffer_lines[result[2][0]][0..result[2][1]].strip =~ /^#/
          chomped = result[1].chomp
          chomped = '#' if result[2][0] == 0 && chomped =~ /^#\s*frozen_string_literal:/
          @comments[result[2][0]] = Snippet.new(Range.from_to(result[2][0], result[2][1], result[2][0], result[2][1] + chomped.length), chomped)
        end
        result
      end

      def on_embdoc_beg *args
        result = super
        chomped = result[1].chomp
        @comments[result[2][0]] = Snippet.new(Range.from_to(result[2][0], result[2][1], result[2][0], result[2][1] + chomped.length), chomped)
        result
      end

      def on_embdoc *args
        result = super
        chomped = result[1].chomp
        @comments[result[2][0]] = Snippet.new(Range.from_to(result[2][0], result[2][1], result[2][0], result[2][1] + chomped.length), chomped)
        result
      end

      def on_embdoc_end *args
        result = super
        chomped = result[1].chomp
        @comments[result[2][0]] = Snippet.new(Range.from_to(result[2][0], result[2][1], result[2][0], result[2][1] + chomped.length), chomped)
        result
      end

      def parse
        @comments = {}
        super
        @comments
      end
    end
  end
end
