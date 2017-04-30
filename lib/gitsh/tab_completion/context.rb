require 'gitsh/lexer'

module Gitsh
  module TabCompletion
    class Context
      def initialize(input)
        @input = input
      end

      def prior_words
        words[0...-1]
      end

      def completing_variable?
        last_meaningful_token(tokens).type == :VAR
      end

      private

      attr_reader :input

      def words
        @_words ||= tokens.reverse_each.inject(['']) do |words, token|
          case token.type
          when :WORD
            words[0] = "#{token.value}#{words[0]}"
            words
          when :VAR
            words[0] = "${#{token.value}}#{words[0]}"
            words
          when :SPACE
            [''] + words
          when :AND, :OR, :SEMICOLON, :LEFT_PAREN, :SUBSHELL_START, :EOL
            return words
          else
            words
          end
        end
      end

      def tokens
        @_tokens ||= lex
      end

      def lex
        Lexer.lex(input)
      rescue RLTK::LexingError
        if input =~ /\$\z/
          lex_with_suffix('x', strip: 'x')
        elsif input =~ /\$\{(#{Lexer::VARIABLE_NAME})?\z/
          lex_with_suffix('x}', strip: 'x')
        else
          raise
        end
      end

      def lex_with_suffix(suffix, options={})
        strip = options.fetch(:strip)
        tokens = Lexer.lex("#{input}#{suffix}")
        last_meaningful_token(tokens).value.sub!(/#{strip}\z/, '')
        tokens
      end

      def last_meaningful_token(tokens)
        tokens.
          reverse_each.
          drop_while { |token| [:EOS, :MISSING].include?(token.type) }.
          first
      end
    end
  end
end
